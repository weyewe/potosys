CollinsPotosys::Application.routes.draw do
  devise_for :users
  # root :to => 'home#dashboard'
   root :to => 'home#homepage'

  resources :articles do 
    resources :article_pictures 
  end
=begin
  Article Publishing
=end
  match 'new_independent_article' => 'articles#new_independent_article', :as => :new_independent_article
  match 'create_independent_article' => 'articles#create_independent_article', :as => :create_independent_article


  
  
  match 'finalize_article' => "articles#finalize_article", :as => :finalize_article
  
  
  # Update Title, Teaser
  match 'edit_article_content/:article_id' => 'articles#edit_article_content', :as => :edit_article_content
  match 'update_article_content/:article_id' => 'articles#update_article_content', :as => :update_article_content
  
  # add the display images
  match 'edit_image_ordering/:article_id' => 'articles#edit_image_ordering', :as => :edit_image_ordering
  match 'update_image_ordering/:article_id/:independent_article_value' => 'articles#update_image_ordering', :as => :update_image_ordering
  
  
  match 'create_article_picture_from_assembly/:article_id' => "article_pictures#create_article_picture_from_assembly", :as => :create_article_picture_from_assembly, :method => :post
  match 'transloadit_status_for_article_picture' => "article_pictures#transloadit_status_for_article_picture", :as => :transloadit_status_for_article_picture, :method => :post
  match 'show_article_picture_as_teaser' => 'article_pictures#show_article_picture_as_teaser', :as => :show_article_picture_as_teaser , :method => :post 
  
  
  match 'edit_publication/:article_id' => 'articles#edit_publication', :as => :edit_publication
  match 'update_publication/:article_id' => "articles#update_publication", :as => :update_publication , :method => :post
  
  match 'select_article_to_upload_for_front_page_image' => 'articles#select_article_to_upload_for_front_page_image', :as => :select_article_to_upload_for_front_page_image
  match 'select_or_upload_front_page_image' => 'articles#select_or_upload_front_page_image', :as => :select_or_upload_front_page_image
  # match 'upload_front_page_image' => 'articles#upload_front_page_image', :as => :upload_front_page_image

  match 'execute_select_front_page' => "article_pictures#execute_select_front_page", :as => :execute_select_front_page, :method => :post
  
  
=begin
  FRONT PAGE DISPLAY
=end
  match 'blog/:article_id' => 'home#blog', :as => :blog
  match 'portfolio' => 'home#portfolio', :as => :portfolio
end
