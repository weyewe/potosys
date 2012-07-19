class ArticlePicture < ActiveRecord::Base
  attr_accessible :assembly_url , :is_completed , :article_id 
  belongs_to :article 
  
  def ArticlePicture.create_from_assembly_url(assembly_url, article)
    pic = ArticlePicture.create(:assembly_url => assembly_url, :is_completed => false , :article_id => article.id)
    
    pic.delay.extract_from_assembly_url
    return pic
  end
  
  def extract_from_assembly_url
    content = open(self.assembly_url).read
    # json = JSON.parse(content)
    
    
    
    transloadit_params = ActiveSupport::HashWithIndifferentAccess.new(
          ActiveSupport::JSON.decode content
        )
        
    while transloadit_params[:ok] != "ASSEMBLY_COMPLETED"
      sleep 2
      puts "in the loop"
      content = open(self.assembly_url).read
      transloadit_params = ActiveSupport::HashWithIndifferentAccess.new(
            ActiveSupport::JSON.decode content
          )
    end
    
    # t.string  :original_image_url
    # t.string  :article_image_url
    # t.string  :front_page_image_url  # not generated yet. can be pinged 
    # t.string :index_image_url
    # 
    #  t.integer  :original_image_size
    #   t.integer  :article_image_size
    #   t.integer :front_page_image_size
    #   t.integer :index_image_size
    # 

    puts "the transloadit_params: #{transloadit_params}"
    self.original_image_url  = transloadit_params[:results][':original'].first[:url]
    self.index_image_url     = transloadit_params[:results][:resize_index].first[:url]   
    self.front_page_image_url   = transloadit_params[:results][:resize_front_page].first[:url]     
    self.article_image_url   = transloadit_params[:results][:resize_article].first[:url]   
    
    self.original_image_size = transloadit_params[:results][':original'].first[:size]
    self.index_image_size    = transloadit_params[:results][:resize_index].first[:size]         
    self.front_page_image_size = transloadit_params[:results][:resize_front_page].first[:size]                
    self.article_image_size  = transloadit_params[:results][:resize_article].first[:size]  
    
      
    self.name                = transloadit_params[:results][':original'].first[:name]
    self.width               = transloadit_params[:results][':original'].first[:meta][:width]
    self.height              = transloadit_params[:results][':original'].first[:meta][:height] 
    self.is_completed        = true
    self.save
      
  end
  
  def ArticlePicture.assembled_pic_id_from( pic_id_list ) 
    ArticlePicture.find(:all, :conditions => {
      :id => pic_id_list, 
      :is_completed => true 
    }).map{|x| x.id }
  end
  
  def show_as_teaser
    self.is_displayed_as_teaser = true 
    self.save
  end
  
  
  def cancel_show_as_teaser
    self.is_displayed_as_teaser = false  
    self.save
  end
  
  
end
