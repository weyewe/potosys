class ArticlesController < ApplicationController
  
=begin
  Article Creation
=end
  def new_independent_article
    @new_article = Article.new  
    @is_migrate_from_project = false
    add_breadcrumb "New Article", 'new_independent_article_path'
  end
  
  def create_independent_article
    @article = Article.create_article_with_user_company(params[:article] , current_user )
    if @article.save 
      redirect_to new_independent_article_url( :notice => "Success in creating article with title: <b>#{@article.title}</b>")
    else
      redirect_to new_independent_article_url( :error => "Fail to create article. Title must not be empty")
    end
  end
  
  
=begin
  FINALIZE ARTICLE
=end
  def finalize_article
    @articles = current_user.active_office.articles.order("created_at DESC")
    add_breadcrumb "Finalize Article", 'finalize_article_url'
  end
  
=begin
  Article Content Edit
=end
  def edit_article_content
    edit_content_routine

    add_breadcrumb "Finalize Article", 'finalize_article_url'
    set_breadcrumb_for @article, 'edit_article_content_path' + "(#{@article.id})", 
          "Edit Content"
  end

  def update_article_content
    update_content_routine
    redirect_to edit_article_content_url(@article, :notice => "This is awesome")
  end
  
=begin
  Article Image Ordering
=end

  def edit_image_ordering

    edit_image_ordering_routine
    @new_article_picture = ArticlePicture.new 
    @independent_article_value = ARTICLE_FROM_PROJECT_VALUE
    add_breadcrumb "Finalize Article", 'finalize_article_url'
    set_breadcrumb_for @article, 'edit_image_ordering_path' + "(#{@article.id})", 
          "Edit Image Ordering"
  end

  def update_image_ordering

    update_image_ordering_routine

    if params[:independent_article_value].to_i == INDEPENDENT_ARTICLE_VALUE
      redirect_to edit_independent_article_image_ordering_url( params[:article_id], :notice => "Image Ordering is Successful!" )
      return
    else
      redirect_to edit_image_ordering_url( params[:article_id], :notice => "Image Ordering is Successful!" )
      return 
    end


  end
  
  
=begin
  Article PUBLICATION
=end
  def edit_publication
   
    edit_publication_routine
    
    add_breadcrumb "Finalize Article", 'finalize_article_url'
    set_breadcrumb_for @article, 'edit_publication_path' + "(#{@article.id})", 
          "Edit Publication Date"
  end
  
  def update_publication
    
    update_publication_routine
            
    if not @publication_datetime.nil?
      @article.set_publication_datetime( @publication_datetime.getutc) 
      redirect_to edit_publication_url(@article, :notice => "The publication date is updated successfully")
      return
    else
      redirect_to edit_publication_url(@article, 
            :error => "The publication date <b>#{params[:article][:publication_datetime]}</b> is invalid")
      return 
    end
  end
  
  protected
  def edit_content_routine
    @article = Article.find_by_id params[:article_id]
    @project = @article.project
  end
  def update_content_routine
    @article = Article.find_by_id params[:article_id]
    @article.update_attributes( params[:article] )
  end
  
  
  def edit_image_ordering_routine
    @article = Article.find_by_id params[:article_id]
    @article_pictures = @article.ordered_article_pictures
  end
  def update_image_ordering_routine
    @article = Article.find_by_id params[:article_id]
    @article.extract_image_ordering( params )
  end
  
  
  def edit_publication_routine
    @article = Article.find_by_id params[:article_id]
  end
  def update_publication_routine
    @article = Article.find_by_id params[:article_id]
    @publication_datetime = extract_date_time( 
                  params[:article][:publication_datetime], 
                  '1' , 
                  '0', JAKARTA_HOUR_OFFSET )
  end
  
end
