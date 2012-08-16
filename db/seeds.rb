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
project_management_head_role = Role.create :name => USER_ROLE[:project_management_head]
project_management_role = Role.create :name => USER_ROLE[:project_management]
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


puts "creating user"
admin_employee = office.create_main_user( [admin_role], 
                  :email => 'admin@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  ) 

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
                    
account_executive =   office.create_user( [account_executive_role], 
                      :email => 'post_production@gmail.com',
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

client_1 = office.create_client( marketing_employee_1, 
                :name => "Jimmy Chandra", 
                :address => "Jl. Martimbang 3 no 1, Senayan",
                :mobile => "082125573759",
                :home_phone => "021 535 6369",
                :bb_pin => "32eaa23",
                :email => "jimmy_chan@gmail.com")


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
                                
                                # self.create_by_employee( employee, client , important_event_params)
                                
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

today_date = DateTime.now.yesterday.to_date

puts "today date is #{today_date}"
project_shoot_date = today_date + 15.days
project_starting_date = project_shoot_date - 1.days
project_ending_date = project_shoot_date + 1.days

project_1_params = {"title".to_sym                                 =>"Check This OUt", 
                    "project_guideline".to_sym =>"ahahaha", 
                    "shoot_location".to_sym           =>"Jakarta, INdonesia", 
                    "shoot_date".to_sym               =>  "#{project_shoot_date.month}/#{project_shoot_date.day}/#{project_shoot_date.year}", 
                    "starting_date".to_sym           => "#{project_starting_date.month}/#{project_starting_date.day}/#{project_starting_date.year}", 
                    "ending_date".to_sym         =>"#{project_ending_date.month}/#{project_ending_date.day}/#{project_ending_date.year}"}  
                 
                 
puts "gona create project1 "
project_1 = Project.create_single_package_project( marketing_employee_1, client_1, package_1, max, 
              project_1_params)

              
  
puts "done creating project 1 "
sales_order_1 = project_1.sales_order
puts "done create project_1"


project_shoot_date = today_date + 30.days
project_starting_date = project_shoot_date - 1.days
project_ending_date = project_shoot_date + 1.days

project_2_params = {"title".to_sym                                 =>" AWESOME GRACE", 
                    "project_guideline".to_sym =>"ahahaha", 
                    "shoot_location".to_sym           =>"London, UK", 
                    "shoot_date".to_sym               =>  "#{project_shoot_date.month}/#{project_shoot_date.day}/#{project_shoot_date.year}", 
                    "starting_date".to_sym           => "#{project_starting_date.month}/#{project_starting_date.day}/#{project_starting_date.year}", 
                    "ending_date".to_sym         =>"#{project_ending_date.month}/#{project_ending_date.day}/#{project_ending_date.year}"}
project_2 = Project.create_single_package_project( marketing_employee_1, client_1, package_1, rere, 
              project_2_params)
sales_order_2 = project_2.sales_order

              
              
#                                       
# selected_package_list = [package_1]
# final_negotiated_price = BigDecimal("100000")
# detail_request = "The client want it to be black and white, showing love and adoration."                                      
# puts "****************Create Project***************"
# sales_order = SalesOrder.create_sales_by_marketing( client_1 , marketing_employee_1, 
#                                     selected_package_list, 
#                                     final_negotiated_price, 
#                                     detail_request ) # detail request, if any == detail of client request
#                                     # such as black and white or whatsoever 
#                                     
# puts "key in the shooting date + key in the crew for crew-specific pricing"
# sales_order.projects.each do |project|
#   project.shoot_date = Date.new( 2012, 12, 25 ) 
#   if project.package.is_crew_specific_pricing? 
#     project.add_main_photographer( benny ) 
#   end
# end
# 
# puts "adjusting the deliverables: add deliverable quantity or  add the deliverable sub quantity"
# first_project =  sales_order.projects.first 
# # add / remove deliverable subcription 
# new_deliverable_subcription  = first_project.add_deliverable_subcription( marketing_employee_1, portrait_album_deliverable ) 
# first_project.remove_deliverable_subcription( marketing_employee_1 , new_deliverable_subcription)
# new_deliverable_subcription  = first_project.add_deliverable_subcription( marketing_employee_1, portrait_album_deliverable ) 
# # edit deliverable sub_quantity
# new_deliverable_subcription.set_sub_quantity(marketing_employee_1,  80 )
# 
# # first_project.deliverable_items.create()
#              
#              
# puts "finalizing the sales: manifesting the main photographer schedule etc"
# sales_order.finalize_sales( marketing_employee_1 )
# 
# puts "\nBACKOFFICE WORK. HEAD PM assigns project manager, assistant photographer, digital imaging team and account executive"
# 
# sales_order.projects.each do |project|
#   project.assign_role( head_project_manager, project_manager, PROJECT_ROLE[:project_manager] )
#   project.assign_role( head_project_manager, account_executive, PROJECT_ROLE[:account_executive] )
#   project.assign_role( head_project_manager, graphic_designer, PROJECT_ROLE[:graphic_designer] )
#   project.assign_role( head_project_manager, amateur_1, PROJECT_ROLE[:photographer] )
#   project.finalize_role_assignment( head_project_manager )
# end
# 
# 
# # DONE, the marketing is done. The next phase is passing the raw files to the Digital Imaging (DI) team
# 
# 
# puts "\n************PASSING THE RAW FILES TO THE DI TEAM***********\n"
# 
# # photographer select project, select package, add input the number of images
# # ideally, photographer upload the images to the central server 
# 
# # photographer, create submission of raw files based on package. but, the file is simple too much. 
# # uploading 5GB? that's a lot. ahahaha.
# 
# 
# sales_order.projects.each do |project|
#   project.submitted_raw_data( benny ) # the photographers log in, report that he has passed the data 
# end
# 
# 
# puts "\n******** Account Executive receives raw files******"
# sales_order.projects.each do |project|
#   project.approve_raw_data_submission( account_executive )  # the photographers log in, report that he has passed the data 
#   # on raw data submission approval, if the package type is video, auto approve selection process. move directly to 
#   # the draft-feedback-revision cycle 
# end
# 
# # optimized for photo 
# =begin
#   It means that all data entries that are specific to photography industry, must be automated. 
#   Auto Create the Date. whatsoever. 
# =end
# 
# puts "\n********** Start the photo selection work *********"
# photo_project = sales_order.projects.joins(:package).where(:package => {:package_medium => PACKAGE_MEDIUM[:photo]}  ).first 
# 
# # now, the ball is in the account executive. he has to click "SENT PIC FOR SELECTION + description"
# 
# # setup the big picture # auto create reminder 
# pre_production_deadline = photo_project.create_deadline( PROJECT_MILESTONE[:pre_production], project_manager, Date.new(2012, 10, 20) )
# # in photo, preproduction means the process where client selects picture
# production_deadline = photo_project.create_deadline( PROJECT_MILESTONE[:production], project_manager, Date.new(2012, 10, 20) )
# # in photo, productionm means the album creation process
# # at the last step of album creation, the image editing takes place
# post_production_deadline= photo_project.create_deadline( PROJECT_MILESTONE[:post_production], project_manager, Date.new(2012, 10, 20) )
# # post production is the deliverables creation process 
# 
# 
# puts "\n******* Get client to select images *********"
# photo_project.pre_production_start( account_executive)   # at current date 
# # assigning task. # to the account executive. do a call based on that . 
# photo_project.pre_production_end( account_executive ) # at the current Date when it is clicked 
# # auto create Milestone (actual) -> actual_pre_production finish
# # 2 cases: what if it is  early?  -> shift the future deadline to be earlier 
# #           what if it is late ?  -> shift the future deadline to be later. example? 
# 
# #  account executive process the client feedback to graphic_designer-friendly task 
# 
# puts "\n******* Start the draft-feedback-revision-work*********"
# #  on revision, account executive create contact report 
# # to trace the topics discussed with client 
# draft_1 = photo_project.create_draft( account_executive )
# draft_1.add_overall_guideline(account_executive, "Client Message")
# draft_1.create_deadline( account_executive, Date.new(2012, 10, 30) )
# # auto create milestone (tentative). milestone will be related to reminder. 
#   
#  
#  
# draft_1_task_1 = draft_1.create_digital_imaging_task( account_executive, "Clean the face", nil) # if there is transloadit params, use the transloadit params
# draft_1_task_2 = draft_1.create_digital_imaging_task( account_executive, "Clean the face", nil)
# 
# 
# 
# 
# draft_1.propose_finalization( graphic_designer )   # the client return the draft, with some feedbacks 
# draft_1.approve_finalization( graphic_designer_head )
# 
# draft_1.assign_internal_deadline_for_client_review(account_executive) # and pass it to the client 
# # after many calls and reminder 
# draft_1.assign_actual_review_done_date( account_executive )
# 
# # over here, the account executive can decide: another draft or finalize
# # we are going for finalization 
# 
# photo_project.reload!
# photo_project.finalize_production( account_executive ) 
# # we move to deliverables creation 
# 
# # Package == template
# # Deliverable == template 
# # The one in actual project: referring to the template 
# # ActualPackage has_many ActualDeliverable  << can be added. 
# #PackageSubcription has fields
# # 1. tentative deadline for pre-production (for photo, it means the image selection)
# # 2. Actual preproduction Finish date
# # 3. Production tentative deadline
# # 4. Actual Production Finish Date
# # 5. Tentative Package Deadline Date
# # 6. Actual Package  Finish Date
# 
# # Project has_many :packages through :package_subcription
# # PackageSubcription has_many :deliverables through :deliverable_subcription 
# 
# #deliverable_subcription has 3 status
# # 1. started  # if it is outsourced, it means PO has been given to the supplier , if it is inhouse, production has started
# # 2. done     # if it 
# # 3. delivered
# 
# 
# 
# # latest question: 1 project 1 package. or multiple project multiple package?
# # i prefer the 1 project 1 package. If the client is getting multiple project + negotiation price, how? 
# # 1 SalesOrder, multiple project. each project => linked to 1 package. that's it.  HAhaha. team has to be assembled for each project. 
# # 1 SalesOrder, 1 price for all the packages selected . 
# 
# 
# =begin
#   POST PRODUCTION 
# =end
# 
# # start deliverable, send to supplier 
# photo_project.deliverable_items.each do |deliverable|
#   deliverable.start_production(account_executive)
# end
# 
# photo_project.reload!
# photo_project.deliverable_items.each do |deliverable|
#   deliverable.approve_finish_production(account_executive)
# end
# 
# photo_project.reload!
# photo_project.deliverable_items.each do |deliverable|
#   deliverable.deliver_to_client(account_executive)
# end
# 
# photo_project.finish_project( project_manager )
