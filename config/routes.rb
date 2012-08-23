CollinsPotosys::Application.routes.draw do
  devise_for :users
  # root :to => 'home#dashboard'
   root :to => 'home#homepage'

  resources :articles do 
    resources :article_pictures 
  end
  
  resources :suppliers 
  resources :deliverables 
  resources :packages do 
    resources :package_assignments 
  end
  
  resources :clients do
    resources :contact_reports
    resources :important_events
    resources :sales_orders
  end
  
  
  resources :packages do 
    resources :deliverable_subcriptions 
  end
  
  resources :projects do 
    resources :project_memberships 
    resources :drafts 
  end
  
  resources :drafts do 
    resources :tasks 
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
  
  match 'contact_person_info/:supplier_id' => 'suppliers#contact_person_info', :as => :contact_person_info
  
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
    match 'select_crew_to_be_booked/:package_id/for_client/:client_id' => 'projects#select_crew_to_be_booked', :as => :select_crew_to_be_booked
    match 'book_crew_for_single_package_sales_order/:package_id/for_client/:client_id/with_crew/:user_id' => 'projects#book_crew_for_single_package_sales_order', :as => :book_crew_for_single_package_sales_order
    match 'execute_crew_booking_for_single_package_sales_order/:package_id/for_client/:client_id/with_crew/:user_id' => 'projects#execute_crew_booking_for_single_package_sales_order', :as => :execute_crew_booking_for_single_package_sales_order, :method => :post 
  
  # for non-crew-specific-pricing, just Finalize the project / sales order 
  
  # then, confirm the sales order. By confirming, it means we can't reduce the number of deliverable items. adding is fine. 
  match 'single_package_sales_order_finalization/:sales_order_id' => 'sales_orders#single_package_sales_order_finalization', :as => :single_package_sales_order_finalization  
  match 'create_new_deliverable_item_from_single_package_sales_order_finalization/:sales_order_id' => 'sales_orders#create_new_deliverable_item_from_single_package_sales_order_finalization', :as => :create_new_deliverable_item_from_single_package_sales_order_finalization, :method => :post
  match 'execute_destroy_deliverable_item_single_package_sales_order' => 'deliverable_items#execute_destroy_deliverable_item_single_package_sales_order' , :as => :execute_destroy_deliverable_item_single_package_sales_order, :method => :post 
  match 'finalize_sales_order_single_package/:sales_order_id' => 'sales_orders#finalize_sales_order_single_package' , :as => :finalize_sales_order_single_package, :method => :post 
  match 'single_package_sales_order_finalized/:sales_order_id' => 'sales_orders#single_package_sales_order_finalized' , :as => :single_package_sales_order_finalized 
  match 'cancel_single_package_sales_order/:sales_order_id' => 'sales_orders#cancel_single_package_sales_order' , :as => :cancel_single_package_sales_order, :method => :post 
  
  # for now, create the basic version: no add/reduce the deliverable item 
  
=begin
  INITIATE BACK OFFICE PROCESS : assign project Membership + PROJECT ROLE to employee
=end
  match 'select_project_for_project_membership_assignment' => 'projects#select_project_for_project_membership_assignment', :as => :select_project_for_project_membership_assignment
  match 'select_role_to_assign_employee/:project_id' => 'projects#select_role_to_assign_employee', :as => :select_role_to_assign_employee
  match 'assign_member_with_selected_project_role/:project_role_id/to_project/:project_id' => 'project_memberships#assign_member_with_selected_project_role_to_project', :as => :assign_member_with_selected_project_role_to_project

=begin
  START PROJECT
=end  
  match 'select_project_to_be_started' => 'projects#select_project_to_be_started', :as => :select_project_to_be_started
  match 'start_project' => 'projects#start_project', :as => :start_project, :method => :post 
  
=begin
  PRODUCTION management
=end
  match 'select_project_to_manage_production' => 'projects#select_project_to_manage_production', :as => :select_project_to_manage_production
  
=begin
  PROJECT MANAGER PART, schedule production
=end
  match 'select_project_to_be_scheduled_in_production_mode' => 'projects#select_project_to_be_scheduled_in_production_mode', :as => :select_project_to_be_scheduled_in_production_mode
  match 'assign_deadline_for_draft/:draft_id' => 'drafts#assign_deadline_for_draft', :as => :assign_deadline_for_draft
  match 'update_draft_deadline/:draft_id' => 'drafts#update_draft_deadline', :as => :update_draft_deadline , :method => :post 

  
=begin
  Account Executive, finalize production 
=end
  match 'finalize_production/:project_id' => 'projects#finalize_production', :as => :finalize_production, :method => :post 
  match 'cancel_production_finalization/:project_id' => 'projects#cancel_production_finalization', :as => :cancel_production_finalization, :method => :post
  
  match 'finish_draft/:draft_id' => 'drafts#finish_draft', :as => :finish_draft , :method => :post
  match 'cancel_draft_finish/:draft_id' => 'drafts#cancel_draft_finish', :as => :cancel_draft_finish , :method => :post
  
  
  
=begin
  POST PRODUCTION, ACCOUNT EXECUTIVE 
=end
  
  match 'select_project_to_monitor_post_production' => 'projects#select_project_to_monitor_post_production', :as => :select_project_to_monitor_post_production
  match 'select_project_to_be_scheduled_in_post_production_mode' => 'projects#select_project_to_be_scheduled_in_post_production_mode', :as => :select_project_to_be_scheduled_in_post_production_mode
  match 'show_deliverable_items_progress' => 'deliverable_items#show_deliverable_items_progress', :as => :show_deliverable_items_progress
  match 'assign_deadline_for_post_production/:project_id' => 'projects#assign_deadline_for_post_production', :as => :assign_deadline_for_post_production
  match 'create_post_production_job_request/:project_id' => 'job_requests#create_post_production_job_request', :as => :create_post_production_job_request , :method => :post
  
=begin
  POST PRODUCTION, PRODUCTION TEAM 
=end
  match 'select_project_to_update_production_progress' => 'projects#select_project_to_update_production_progress', :as => :select_project_to_update_production_progress
  match 'select_deliverable_to_update_progress/:project_id' => 'deliverable_items#select_deliverable_to_update_progress', :as => :select_deliverable_to_update_progress
  
  # start the deliverable creation
  match 'start_deliverable_item_creation/:deliverable_item_id' => 'deliverable_items#start_deliverable_item_creation', :as => :start_deliverable_item_creation
  match 'execute_start_deliverable_item_creation/:deliverable_item_id' => 'deliverable_items#execute_start_deliverable_item_creation', :as => :execute_start_deliverable_item_creation, :method => :post 
  
  # finish the deliverable creation ( retrive the finished good, ready to be sent to client)
  match 'finish_deliverable_item_creation/:deliverable_item_id' => 'deliverable_items#finish_deliverable_item_creation', :as => :finish_deliverable_item_creation
  match 'execute_finish_deliverable_item_creation/:deliverable_item_id' => 'deliverable_items#execute_finish_deliverable_item_creation', :as => :execute_finish_deliverable_item_creation, :method => :post
  
  # deliver the deliverable_item -> personal delivery, courier 
  match 'deliver_deliverable_item_creation/:deliverable_item_id' => 'deliverable_items#deliver_deliverable_item_creation', :as => :deliver_deliverable_item_creation
  match 'execute_deliver_deliverable_item_creation/:deliverable_item_id' => 'deliverable_items#execute_deliver_deliverable_item_creation', :as => :execute_deliver_deliverable_item_creation, :method => :post
  
   
  match 'deliverable_items_pending_start' => 'deliverable_items#deliverable_items_pending_start', :as => :deliverable_items_pending_start
  match 'deliverable_items_pending_finish' => 'deliverable_items#deliverable_items_pending_finish', :as => :deliverable_items_pending_finish
  match 'deliverable_items_pending_delivery' => 'deliverable_items#deliverable_items_pending_delivery', :as => :deliverable_items_pending_delivery
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
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
