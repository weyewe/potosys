class ArticlePicturesController < ApplicationController
  
  def create_article_picture_from_assembly
    @article = Article.find_by_id( params[:article_id] )
    assembly_url = params[:assembly_url]
    # ensure_project_membership
    
    # @picture = Picture.create_from_assembly_url(assembly_url, @project)
    @article_picture = ArticlePicture.create_from_assembly_url(assembly_url, @article)
    
    respond_to do |format| 
      format.js do 
        is_completed_result = 0 
        if @article_picture.is_completed == true
          is_completed_result= 1
        end
        render :json => {'picture_id' => @article_picture.id, 'is_completed' => is_completed_result}.to_json  
      end
    end
  end
  
  
  def transloadit_status_for_article_picture
    # @picture = Picture.find_by_id( params[:picture_id])
    array_of_assembled_pic_id = ArticlePicture.assembled_pic_id_from( params[:non_completed_pic_id_list].split(",").map{|x| x.to_i })
      
    
    
    respond_to do |format| 
      format.js do 
        # is_completed_result = 0 
        # if @picture.is_completed == true
        #   is_completed_result= 1
        # end
        render :json => array_of_assembled_pic_id.to_json  
      end
    end
  end
  
  
end
