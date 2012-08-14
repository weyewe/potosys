CollinsPotosys::Application.routes.draw do
  devise_for :users
  # root :to => 'home#dashboard'
   root :to => 'home#homepage'

  resources :articles do 
    resources :article_pictures 
  end
  
  resources :deliverables 
  resources :packages do 
    resources :package_assignments 
  end
  
  resources :clients do
    resources :contact_reports
    resources :important_events
    resources :sales_orders
  end
  
  
  
=begin
  SETUP, Create User +  Office Role
=end
  
  match 'new_employee_creation' => "offices#new_employee_creation", :as => :new_employee_creation
  match 'create_employee' => "offices#create_employee" , :as => :create_employee, :method => :post 
  match 'show_role_for_employee/:employee_id' => "offices#show_role_for_employee" , :as => :show_role_for_employee
  match 'assign_role_for_employee' => "offices#assign_role_for_employee" , :as => :assign_role_for_employee, :method => :post
  
  
  
=begin
  MASTER DATA, company specific
  CREATE DELIVERABLE  + PACKAGE
=end

  match 'create_package_assignment' => 'package_assignments#create_package_assignment', :as => :create_package_assignment, :method => :post 
  match 'edit_price_package/:package_id/crew/:crew_id' => 'package_assignments#edit_crew_specific_package_price', :as => :edit_crew_specific_package_price, :method => :post 
  
  
  
=begin
  SEARCH CLIENT TO CREATE CONTACT REPORT, SALES ORDER, or Important Event
=end
  match 'search_client_for_marketing_interaction' => 'clients#search_client_for_marketing_interaction', :as => :search_client_for_marketing_interaction
  
  
=begin
  SEE Important Events in the office
=end

  match 'all_important_events' => 'important_events#all_important_events', :as => :all_important_events 
  
=begin
  See crew's calendar
=end

  match 'select_crew_to_view_calendar' => 'offices#select_crew_to_view_calendar', :as => :select_crew_to_view_calendar
  match 'crew_schedule/:user_id' => 'job_requests#crew_schedule', :as => :crew_schedule
  
  
=begin
  Create Sales Order 
=end

  match 'search_client_for_single_package_sales_order' => 'clients#search_client_for_single_package_sales_order', :as => :search_client_for_single_package_sales_order
  match 'select_package_for_single_package_sales_order/:client_id' => 'packages#select_package_for_single_package_sales_order', :as => :select_package_for_single_package_sales_order
  # for the crew-specific-pricing, we need to book the crew
    match 'book_crew_for_single_package_sales_order/:package_id/for_client/:client_id' => 'projects#book_crew_for_single_package_sales_order', :as => :book_crew_for_single_package_sales_order
    match 'execute_crew_booking_for_single_package_sales_order/:package_id/for_client/:client_id' => 'projects#execute_crew_booking_for_single_package_sales_order', :as => :execute_crew_booking_for_single_package_sales_order, :method => :post 
  
  # for non-crew-specific-pricing, just Finalize the project / sales order 
  
  # then, confirm the sales order. By confirming, it means we can't reduce the number of deliverable items. adding is fine. 
  
  # for now, create the basic version: no add/reduce the deliverable item 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
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
