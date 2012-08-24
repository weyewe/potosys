puts "Photography Studio Management: potosys"

puts "\n*********APPLICATION WIDE SETUP*********\n"
puts "creating roles"
admin_role = Role.create :name => USER_ROLE[:admin]
pro_photographer_role = Role.create :name => USER_ROLE[:pro_photographer]
amateur_photographer_role = Role.create :name => USER_ROLE[:amateur_photographer]
pro_videographer_role = Role.create :name => USER_ROLE[:pro_videographer]
amateur_videographer_role = Role.create :name => USER_ROLE[:amateur_videographer]
marketing_head_role   = Role.create :name => USER_ROLE[:marketing_head]
marketing_role   = Role.create :name => USER_ROLE[:marketing]
graphic_designer_head_role = Role.create :name => USER_ROLE[:graphic_designer_head]
graphic_designer_role = Role.create :name => USER_ROLE[:graphic_designer]
project_management_head_role = Role.create :name => USER_ROLE[:project_manager_head]
project_management_role = Role.create :name => USER_ROLE[:project_manager]
account_executive_role = Role.create :name => USER_ROLE[:account_executive]
publisher_role = Role.create :name => USER_ROLE[:publisher]

post_production_head_role = Role.create :name => USER_ROLE[:post_production_head]
post_production_role = Role.create :name => USER_ROLE[:post_production]

# 
# PROJECT_ROLE = {
#   :account_executive => "AccountExecutive",
#   :graphic_designer => "GraphicDesigner",
#   :project_manager => "ProjectManager" 
#   :crew => "Crew" # crew is those people going out to take picture (handling the supply side)
# }

account_executive_project_role = ProjectRole.create(:name => PROJECT_ROLE[:account_executive] )
graphic_designer_project_role = ProjectRole.create(:name => PROJECT_ROLE[:graphic_designer] )
project_manager_project_role = ProjectRole.create(:name => PROJECT_ROLE[:project_manager] )
crew_project_role = ProjectRole.create(:name => PROJECT_ROLE[:crew] )
post_production_project_role =  ProjectRole.create(:name => PROJECT_ROLE[:post_production] )

puts "\n*********OFFICE WIDE SETUP***********"
puts "creating office"
office = Office.create :name => COMPANY_NAME

if office.nil?
  puts "3333 the office is nil"
else
  puts "The office is not nil, the id is #{office.id}"
end


puts "creating user"
admin_employee = office.create_main_user( [admin_role], 
                  :email => 'admin@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  ) 
puts "after admin"
publisher_employee = office.create_user( [publisher_role], 
                  :email => 'publisher@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
          
marketing_employee_1 =   office.create_user( [marketing_role], 
                    :email => 'marketing_1@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
project_manager_head = office.create_user( [project_management_head_role], 
                    :email => 'head_pm@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
project_manager  = office.create_user( [project_management_role], 
                    :email => 'pm@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
graphic_designer_head = office.create_user( [graphic_designer_head_role], 
                    :email => 'graphic_designer_head@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
graphic_designer = office.create_user( [graphic_designer_role], 
                    :email => 'graphic_designer@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
post_production_head = office.create_user( [post_production_head_role], 
                    :email => 'post_production_head@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
post_production = office.create_user( [post_production_role], 
                    :email => 'post_production@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
account_executive =   office.create_user( [account_executive_role,graphic_designer_role], 
                      :email => 'ae@gmail.com',
                      :password => 'willy1234',
                      :password_confirmation => 'willy1234'  )

puts "creating photographers"
benny = office.create_user( [pro_photographer_role], 
                  :email => 'benny@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
                  
max = office.create_user( [pro_photographer_role], 
                  :email => 'max@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
                  
rere = office.create_user( [pro_photographer_role], 
                  :email => 'rere@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
                  
amateur_1 = office.create_user( [amateur_photographer_role], 
                  :email => 'amateur_1@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
amateur_2 = office.create_user( [amateur_photographer_role], 
                  :email => 'amateur_2@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )


puts "create supplier"
(1..10).each do |count|
  office.create_supplier( admin_employee, :name => "Supplier #{count}") 
end



puts "\n************ MASTER DATA: Package + Deliverables ************"
puts "\n creating deliverable"
#  for photos
portrait_album_deliverable = office.create_deliverable(admin_employee,  
                      :name => "Portrait Album", 
                      :independent_price => "5000000",
                      :has_sub_item => true,
                      :sub_item_name => "Edited Pic",
                      :sub_item_quantity => '40',
                      :independent_sub_item_price => "100000")
                      
cd_high_res_pics_deliverable = office.create_deliverable( admin_employee,
              :name => "CD with high res pics", 
              :independent_price => "500000",
              :has_sub_item => true,
              :sub_item_name => "Edited Pic",
              :sub_item_quantity => '30',
              :independent_sub_item_price => '70000')
framed_canvas_60_x_40_deliverable = office.create_deliverable(admin_employee,  :name => "Framed Canvas 60x40cm", :independent_price => "1500000", :has_sub_item => false)
photoclip_deliverable = office.create_deliverable( admin_employee, :name => "Photoclip with selected photos", :independent_price => "50000",:has_sub_item => false)

# for videos
original_video_copy = office.create_deliverable(admin_employee, :office_id => office.id, :name => "Original Video Copy", :has_sub_item => false)


puts "Assign deliverable to Package"

# puts "\n creating package"
puts "create package"
package_1 = office.create_package( admin_employee, :name => "Junia Candid Photo Sessions", 
              :base_price => "5000000",
              :number_of_crew => 2,  
              :is_crew_specific_pricing => true ) # if it is crew specific, the client can choose the main crew 
              
package_1.assign_deliverable(admin_employee, :deliverable_id => cd_high_res_pics_deliverable.id, :package_specific_sub_item_quantity => '15' )
package_1.assign_deliverable(admin_employee, :deliverable_id => framed_canvas_60_x_40_deliverable.id, :package_specific_sub_item_quantity => '15' )

package_1.assign_crew_to_package( max , admin_employee )
package_1.edit_crew_specific_pricing(max, admin_employee, '15000000' )


package_1.assign_crew_to_package( rere , admin_employee )
package_1.edit_crew_specific_pricing(rere, admin_employee, '10000000' )

puts "\n************Creating Client***********"
client_array = [] 

(1..10).each do |count| 
  client = office.create_client( marketing_employee_1, 
                  :name => "Jimmy Chandra #{count}", 
                  :address => "Jl. Martimbang #{count} no 1, Senayan",
                  :mobile => "08212#{count}759",
                  :home_phone => "021 535 #{count}69",
                  :bb_pin => "32e#{count}3",
                  :email => "client_#{count}@gmail.com")
  client_array << client 
end





                                
client_array.each do |client|
  contact_report = ContactReport.create_by_employee( marketing_employee_1 , client , 
                                  :contact_datetime => "8/5/2012" ,
                                  :contact_hour => 15, 
                                  :summary => "Request for Wedding Shot",
                                  :description => "The client is asking for wedding shot for 12 September 2012. " + 
                                  "However, he thinks that the quoted " + 
                                  "price is way too expensive." 
                                  )
end

client_1 = client_array[0]
puts "\n************Creating Contact Report***********"

contact_report_1 = ContactReport.create_by_employee( marketing_employee_1 , client_1 , 
                                :contact_datetime => "8/5/2012" ,
                                :contact_hour => 15, 
                                :summary => "Request for Wedding Shot",
                                :description => "The client is asking for wedding shot for 12 September 2012. " + 
                                "However, he thinks that the quoted " + 
                                "price is way too expensive." 
                                )
                                
                        
contact_report_2 = ContactReport.create_by_employee( marketing_employee_1 , client_1 , 
                                :contact_datetime => "8/5/2012" ,
                                :contact_hour => 10, 
                                :summary => "Follow Up for Wedding Shot request",
                                :description => "We negotiated for 20% discount. The base price is 30 million, with Beny as the photographer. " + 
                                "This client's point is agreeable since it is the low season." 
                                )
                                
puts "creating important event"                

important_event_1 = ImportantEvent.create_by_employee( marketing_employee_1, client_1,  
                                      :event_date => '9/20/2012',
                                      :is_repeating_annually => true,
                                      :title => "12 September is Jammie (client's son) bday.")
                                      
important_event_2 = ImportantEvent.create_by_employee( marketing_employee_1, client_1,  
                                      :event_date => '12/15/2012',
                                      :is_repeating_annually => false,
                                      :title => "It is the 1 month anniversary of their son's bday.")
                                      
puts "\n****************Create Project***************\n" 

pro_crew_array = [benny, max,rere]
finished_project_array = [] 
puts "gonna create 7 past projects, and finish it before Date.now"
today_date = DateTime.now.yesterday.to_date
last_month_date = today_date - 1.months
(1..7).each do |count|
  pro_crew = pro_crew_array[ rand(pro_crew_array.length) ] 
  project_shoot_date   = last_month_date + (count*3).days 
  project_starting_date  = ''
  project_ending_date    = '' 
  loop {
     
     project_starting_date  = project_shoot_date - rand(3).days
     project_ending_date    = project_shoot_date  + rand(3).days
     break unless not  pro_crew.is_available_for_booking?( project_starting_date, project_ending_date, office )
   }
   
   
  
  client = client_array[ rand(client_array.length) ] 
  
  # project_params = {"title".to_sym                                 =>"#{client.name} Project", 
  #                     "project_guideline".to_sym =>"ahahaha", 
  #                     "shoot_location".to_sym           =>"Jakarta, INdonesia", 
  #                     "shoot_date".to_sym               =>  "#{project_shoot_date.month}/#{project_shoot_date.day}/#{project_shoot_date.year}", 
  #                     "starting_date".to_sym           => "#{project_starting_date.month}/#{project_starting_date.day}/#{project_starting_date.year}", 
  #                     "ending_date".to_sym         =>"#{project_ending_date.month}/#{project_ending_date.day}/#{project_ending_date.year}"}
  project = Project.new     
  project.title = "Project #{client.name} " 
  project.shoot_location = "Jakarta, INdonesia"
  puts "project shoot date= #{project_shoot_date}"
  puts "project starting date= #{project_starting_date}"
  puts "project ending date= #{project_ending_date}"
  
  project.shoot_date = project_shoot_date
  project.starting_date = project_starting_date
  project.ending_date = project_ending_date

  project.selected_pro_crew_id =  pro_crew.id
  project.client_id = client.id 
  project.package_id = package_1.id 
  project.creator_id = marketing_employee_1.id 
  project.office_id = office.id 
  project.save

  project.create_project_membership_assignment_for_selected_pro_crew 
  project.create_corresponding_job_request_for_crew_specific_pricing
  sales_order = project.sales_order # after_create project, sales order creation 
  #  confirm sales order 
  sales_order.confirm_sales_order(marketing_employee_1, :total_transaction_amount => '15000000')
  
  # add project membership : must have account executive, graphic designer, post_production, project_manager 
  project.add_project_membership( project_manager_head, account_executive,  account_executive_project_role , false )
  project.add_project_membership( project_manager_head, graphic_designer,  graphic_designer_project_role , false )
  project.add_project_membership( project_manager_head, post_production,  post_production_project_role , false )
  project.add_project_membership( project_manager_head, project_manager,  project_manager_project_role , false )

  # project.start_project(project_manager_head  ), we need to capture the date
  project.is_started = true
  project.project_start_date = project.shoot_date + 2.days
  project.save
  
  puts "before creating the draft"
  
  # create the draft? 
  
  # (1..2).each do |draft_count|
  #    # @project.create_draft( account_executive, params[:draft]) 
  #    draft = Draft.new 
  #    draft.number = draft_count 
  #    last_draft = project.last_draft 
  #    puts "first shite"
  #    if last_draft.nil?
  #      puts "a"
  #      draft.proposed_deadline_date =  project.shoot_date + 4.days
  #      puts "after a"
  #    else
  #      puts "b"
  #      draft.proposed_deadline_date =  last_draft.finish_date + 4.days
  #      puts "after b"
  #    end
  #    draft.overall_feedback  = "Make it more awesome etc"
  #    draft.deadline_proposer_id = account_executive.id 
  #    draft.project_id = project.id 
  #    draft.save 
  #    
  #    # pm grant the deadline date 
  #     result = draft.set_granted_deadline_date(project_manager ,  draft.proposed_deadline_date )
  #     if result.nil?
  #       puts "THE FUCKING RESULT IS NIL"
  #     else
  #       puts "THE AWESOME RESULT IS NOT NIL"
  #     end
  #     
  #     puts "#{draft_count}, granted_deadline_date: #{draft.granted_deadline_date}"
  #     #  finish the draft, declared as finish by the account executive 
  #     puts "second shite\n"
  #     # draft.finish_draft( account_executive , draft.proposed_deadline_date + 1.days  ) 
  #     draft.is_finished = true 
  #     draft.finish_date  = draft.granted_deadline_date + 1.days
  #     draft.finisher_id = account_executive.id
  #     draft.save
  #  end
  
   
   
  
  finished_project_array << project 
  
end 





# 
# puts "today date is #{today_date}"
# project_shoot_date = today_date + 4.days
# project_starting_date = project_shoot_date - 1.days
# project_ending_date = project_shoot_date + 1.days
# 
# project_1_params = {"title".to_sym                                 =>"Check This OUt", 
#                     "project_guideline".to_sym =>"ahahaha", 
#                     "shoot_location".to_sym           =>"Jakarta, INdonesia", 
#                     "shoot_date".to_sym               =>  "#{project_shoot_date.month}/#{project_shoot_date.day}/#{project_shoot_date.year}", 
#                     "starting_date".to_sym           => "#{project_starting_date.month}/#{project_starting_date.day}/#{project_starting_date.year}", 
#                     "ending_date".to_sym         =>"#{project_ending_date.month}/#{project_ending_date.day}/#{project_ending_date.year}"}  
#                  
#                  
# puts "gona create project1 "
# project_1 = Project.create_single_package_project( marketing_employee_1, client_1, package_1, max, 
#               project_1_params)
#               
# 
# 
#               
#   
# puts "done creating project 1 "
# sales_order_1 = project_1.sales_order
# puts "confirming sales order 1 "
# sales_order_1.confirm_sales_order(marketing_employee_1, :total_transaction_amount => '15000000')
# puts "done create project_1"
# 
# 
# project_shoot_date = today_date + 30.days
# project_starting_date = project_shoot_date - 1.days
# project_ending_date = project_shoot_date + 1.days
# 
# project_2_params = {"title".to_sym                                 =>" AWESOME GRACE", 
#                     "project_guideline".to_sym =>"ahahaha", 
#                     "shoot_location".to_sym           =>"London, UK", 
#                     "shoot_date".to_sym               =>  "#{project_shoot_date.month}/#{project_shoot_date.day}/#{project_shoot_date.year}", 
#                     "starting_date".to_sym           => "#{project_starting_date.month}/#{project_starting_date.day}/#{project_starting_date.year}", 
#                     "ending_date".to_sym         =>"#{project_ending_date.month}/#{project_ending_date.day}/#{project_ending_date.year}"}
# project_2 = Project.create_single_package_project( marketing_employee_1, client_1, package_1, rere, 
#               project_2_params)
# sales_order_2 = project_2.sales_order
# 
# 
# puts "\n*************** Assigning Project Membership ************\n"
# # there has to be
# # 1 account executive
# # 1 project manager
# # 1 graphic designer 
# # 1 post_production 
# 
#  
# 
# project_1.add_project_membership( project_manager_head, account_executive,  account_executive_project_role , false )
# project_1.add_project_membership( project_manager_head, graphic_designer,  graphic_designer_project_role , false )
# project_1.add_project_membership( project_manager_head, post_production,  post_production_project_role , false )
# project_1.add_project_membership( project_manager_head, project_manager,  project_manager_project_role , false )
# 
# project_1.start_project(project_manager_head  )
# 
# project_2.add_project_membership( project_manager_head, account_executive,  account_executive_project_role , false )
# project_2.add_project_membership( project_manager_head, account_executive,  graphic_designer_project_role , false )
# project_2.add_project_membership( project_manager_head, post_production,  post_production_project_role , false )
# project_2.add_project_membership( project_manager_head, project_manager,  project_manager_project_role , false )
#       
# project_2.start_project(project_manager_head  )
#               
# today_date = project_1.shoot_date + 5.days # project shoot date is at + 15.days
# proposed_date = today_date + 10.days
# puts "\n Skipping the pre-supply. We are going all the way for production phase. with draft1\n"
# draft_1 = project_1.create_draft( account_executive, :overall_feedback => 'Make it Awesome!', 
#         :proposed_deadline_date => "#{proposed_date.month}/#{proposed_date.day}/#{proposed_date.year}")  # proposed deadline included 

