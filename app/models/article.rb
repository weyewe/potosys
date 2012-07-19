class Article < ActiveRecord::Base
  attr_accessible :title, :sub_title, :description, :teaser 
  belongs_to :project
  has_many :article_pictures 
  
  
  belongs_to :office
  belongs_to :user 
  
  validates_presence_of :title 
  
  before_destroy :destroy_all_article_pics
  
=begin
  Creating Independent Article
=end

  def self.create_article_with_user_company(article_hash, current_user)
    if not current_user.has_role?(:publisher)
      return false
    end

    office = current_user.active_office
    article = Article.create article_hash 

    article.user_id = current_user.id
    article.office_id = office.id
    article.article_type = ARTICLE_TYPE[:independent_article]
    article.save 

    return article
  end
  
  
  def destroy_all_article_pics
    self.article_pictures.each do |article_pic|
      
      article_pic.is_deleted = true
      article_pic.save 
    end
  end
  
=begin
  Publication Logic
=end
  def has_content?
    ( not self.title.nil?   and not self.title.length == 0 ) or 
    (not self.description.nil? and not self.description.length == 0 ) or 
    (not self.teaser.nil? and not self.teaser.length == 0 )
  end
  
  def any_article_pictures_shown?
    self.article_pictures.where{
      (article_display_order.gt 0)
    }.count > 0 
  end
  
  def ordered_article_pictures
    ArticlePicture.find(:all, :conditions => {
      :article_id => self.id,
      :is_deleted => false 
    }, :order => "article_display_order ASC")
  end
  
  
  
  
  def total_article_pictures_shown
    self.article_pictures.where{
      (article_display_order.gt 0)
    }.count 
  end
  
  def set_published
    self.is_displayed = true
    self.save
  end
  
  def set_unpublished
    self.is_displayed = false
    self.save
  end
  
  def publication_datetime_localtime 
    #for now, Jakarta by default. They can pick it later 
    if self.publication_datetime.nil?
      return nil
    else
      self.publication_datetime.in_time_zone("Jakarta")
    end
    
  end
  
  def set_publication_datetime( publication_datetime_utc )
    self.publication_datetime = publication_datetime_utc
    self.is_displayed = true
    self.save  
  end
  
  def extract_image_ordering( params ) 
    self.article_pictures.each do |pic|
      name = "article_picture_#{pic.id}"
      if params[name.to_sym].nil?
        next
      else
        pic.article_display_order = params[name.to_sym].to_i
        pic.save
      end
      
    end
  end
  
=begin
  FRONT PAGE LOGIC
=end

  def self.frontpage_article
    Article.includes(:article_pictures).find(:all, 
      :conditions => [ "publication_datetime <= ?", DateTime.now ], 
      :order => "publication_datetime DESC")
  end
  
  def frontpage_article_pictures
    ArticlePicture.where(:is_deleted => false, :article_id => self.id, 
      :is_displayed_as_teaser => true ).order("article_display_order ASC")
  end
  
  def ordered_blog_article_pictures
    self_article_id  = self.id 
    ArticlePicture.where{
      (article_id.eq self_article_id )  & 
      (is_deleted.eq false) & 
      (article_display_order.gt 0)
    }.order("article_display_order ASC")
  end
  
end
