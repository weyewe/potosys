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
                    :email => 'publisher@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
project_manager_head = office.create_user( [project_management_head_role], 
                    :email => 'head_pm@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
graphic_designer_head = office.create_user( [graphic_designer_head_role], 
                    :email => 'head_pm@gmail.com',
                    :password => 'willy1234',
                    :password_confirmation => 'willy1234'  )
                    
graphic_designer = office.create_user( [graphic_designer_role], 
                    :email => 'head_pm@gmail.com',
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
portrait_album_deliverable = Deliverable.create(:office_id => office.id, :name => "Portrait Album", :has_sub_quantity => true)
cd_high_res_pics_deliverable = Deliverable.create(:office_id => office.id, :name => "CD with high res pics", :has_sub_quantity => false)
framed_canvas_60_x_40_deliverable = Deliverable.create(:office_id => office.id, :name => "Framed Canvas 60x40cm", :has_sub_quantity => false)
photoclip_deliverable = Deliverable.create(:office_id => office.id, :name => "Photoclip with selected photos", :has_sub_quantity => false)

# for videos
original_video_copy = Deliverable.create(:office_id => office.id, :name => "Original Video Copy", :has_sub_quantity => false)


puts "\n creating package"
package_1 = office.create_package( admin_employee, :title => "Junia Candid Photo Sessions", 
              :standard_price => BigDecimal("5000000"),
              :number_of_crew => 2,  
              :is_crew_specific_pricing => true ) # if it is crew specific, the client can choose the main crew 

# package has many deliverables through package_items 
# deliverable has many packages through package_items
# #add_deliverable( deliverable,  sub_item_quantity)
package_1.add_deliverable(portrait_album_deliverable,  40 )
package_1.add_deliverable(cd_high_res_pics_deliverable,  0)
package_1.add_deliverable(framed_canvas_60_x_40_deliverable,  0)
package_1.add_deliverable(photoclip_deliverable, 0)


# package has many users through package_prices
# user has many packages through package_prices
package_1.add_crew(benny, BigDecimal("9600000") ) 
package_1.add_crew(max, BigDecimal("7600000") )
package_1.add_crew(rere, BigDecimal("7000000") )

puts "\n************Creating Client***********"

client_1 = Client.create_by_marketing(marketing_employee_1, 
                                :name => "Jimmy Chandra", 
                                :address => "Jl. Martimbang 3 no 1, Senayan",
                                :mobile => "082125573759",
                                :home_phone => "021 535 6369",
                                :bb_pin => "32eaa23",
                                :email => "jimmy_chan@gmail.com"
                                )
contact_report_1 = ContactReport.create_contact_report_for_client( client_1 , marketing_employee_1, 
                                :contact_datetime => DateTime.now,
                                :title => "Request for Wedding Shot",
                                :date_of_importance => Date.new(2012,9,12),
                                :description => "The client is asking for wedding shot for 12 September 2012. " + 
                                "However, he thinks that the quoted " + 
                                "price is way too expensive.",
                                :contact_purpose =>  CONTACT_PURPOSE[:product_enquiry]  
                                )

important_date_1 = ImportantEvent.create_reminder( client_1, marketing_employee_1, 
                                      :date_of_importance => Date.new(2012, 9, 12),
                                      :number_of_days_in_advance => 15, 
                                      :is_repeating => true,
                                      :description => "12 September is Jammie (client's son) bday.")
                                      
important_date_2 = ImportantEvent.create_reminder( client_1, marketing_employee_1, 
                                      :date_of_importance => Date.new(2012, 10, 12),
                                      :number_of_days_in_advance => 15, 
                                      :is_repeating => false,
                                      :description => "It is the 1 month anniversary of their son's bday.")
                                      
selected_package_list = [package_1]
final_negotiated_price = BigDecimal("100000")
detail_request = "The client want it to be black and white, showing love and adoration."                                      
puts "****************Create Project***************"
sales_order = SalesOrder.create_sales_by_marketing( client_1 , marketing_employee_1, 
                                    selected_package_list, 
                                    final_negotiated_price, 
                                    detail_request ) # detail request, if any == detail of client request
                                    # such as black and white or whatsoever 
                                    
puts "key in the shooting date + key in the crew for crew-specific pricing"
sales_order.projects.each do |project|
  project.shoot_date = Date.new( 2012, 12, 25 ) 
  if project.package.is_crew_specific_pricing? 
    project.add_main_photographer( benny ) 
  end
end

puts "adjusting the deliverables: add deliverable quantity or  add the deliverable sub quantity"
first_project =  sales_order.projects.first 
# add / remove deliverable subcription 
new_deliverable_subcription  = first_project.add_deliverable_subcription( marketing_employee_1, portrait_album_deliverable ) 
first_project.remove_deliverable_subcription( marketing_employee_1 , new_deliverable_subcription)
new_deliverable_subcription  = first_project.add_deliverable_subcription( marketing_employee_1, portrait_album_deliverable ) 
# edit deliverable sub_quantity
new_deliverable_subcription.set_sub_quantity(marketing_employee_1,  80 )

# first_project.deliverable_items.create()
             
             
puts "finalizing the sales: manifesting the main photographer schedule etc"
sales_order.finalize_sales( marketing_employee_1 )

puts "\nBACKOFFICE WORK. HEAD PM assigns project manager, assistant photographer, digital imaging team and account executive"

sales_order.projects.each do |project|
  project.assign_role( head_project_manager, project_manager, PROJECT_ROLE[:project_manager] )
  project.assign_role( head_project_manager, account_executive, PROJECT_ROLE[:account_executive] )
  project.assign_role( head_project_manager, graphic_designer, PROJECT_ROLE[:graphic_designer] )
  project.assign_role( head_project_manager, amateur_1, PROJECT_ROLE[:photographer] )
  project.finalize_role_assignment( head_project_manager )
end


# DONE, the marketing is done. The next phase is passing the raw files to the Digital Imaging (DI) team


puts "\n************PASSING THE RAW FILES TO THE DI TEAM***********\n"

# photographer select project, select package, add input the number of images
# ideally, photographer upload the images to the central server 

# photographer, create submission of raw files based on package. but, the file is simple too much. 
# uploading 5GB? that's a lot. ahahaha.


sales_order.projects.each do |project|
  project.submitted_raw_data( benny ) # the photographers log in, report that he has passed the data 
end


puts "\n******** Account Executive receives raw files******"
sales_order.projects.each do |project|
  project.approve_raw_data_submission( account_executive )  # the photographers log in, report that he has passed the data 
  # on raw data submission approval, if the package type is video, auto approve selection process. move directly to 
  # the draft-feedback-revision cycle 
end

# optimized for photo 
=begin
  It means that all data entries that are specific to photography industry, must be automated. 
  Auto Create the Date. whatsoever. 
=end

puts "\n********** Start the photo selection work *********"
photo_project = sales_order.projects.joins(:package).where(:package => {:package_medium => PACKAGE_MEDIUM[:photo]}  ).first 

# now, the ball is in the account executive. he has to click "SENT PIC FOR SELECTION + description"

# setup the big picture # auto create reminder 
pre_production_deadline = photo_project.create_deadline( PROJECT_MILESTONE[:pre_production], project_manager, Date.new(2012, 10, 20) )
# in photo, preproduction means the process where client selects picture
production_deadline = photo_project.create_deadline( PROJECT_MILESTONE[:production], project_manager, Date.new(2012, 10, 20) )
# in photo, productionm means the album creation process
# at the last step of album creation, the image editing takes place
post_production_deadline= photo_project.create_deadline( PROJECT_MILESTONE[:post_production], project_manager, Date.new(2012, 10, 20) )
# post production is the deliverables creation process 


puts "\n******* Get client to select images *********"
photo_project.pre_production_start( account_executive)   # at current date 
# assigning task. # to the account executive. do a call based on that . 
photo_project.pre_production_end( account_executive ) # at the current Date when it is clicked 
# auto create Milestone (actual) -> actual_pre_production finish
# 2 cases: what if it is  early?  -> shift the future deadline to be earlier 
#           what if it is late ?  -> shift the future deadline to be later. example? 

#  account executive process the client feedback to graphic_designer-friendly task 

puts "\n******* Start the draft-feedback-revision-work*********"
#  on revision, account executive create contact report 
# to trace the topics discussed with client 
draft_1 = photo_project.create_draft( account_executive )
draft_1.add_overall_guideline(account_executive, "Client Message")
draft_1.create_deadline( account_executive, Date.new(2012, 10, 30) )
# auto create milestone (tentative). milestone will be related to reminder. 
  
 
 
draft_1_task_1 = draft_1.create_digital_imaging_task( account_executive, "Clean the face", nil) # if there is transloadit params, use the transloadit params
draft_1_task_2 = draft_1.create_digital_imaging_task( account_executive, "Clean the face", nil)




draft_1.propose_finalization( graphic_designer )   # the client return the draft, with some feedbacks 
draft_1.approve_finalization( graphic_designer_head )

draft_1.assign_internal_deadline_for_client_review(account_executive) # and pass it to the client 
# after many calls and reminder 
draft_1.assign_actual_review_done_date( account_executive )

# over here, the account executive can decide: another draft or finalize
# we are going for finalization 

photo_project.reload!
photo_project.finalize_production( account_executive ) 
# we move to deliverables creation 

# Package == template
# Deliverable == template 
# The one in actual project: referring to the template 
# ActualPackage has_many ActualDeliverable  << can be added. 
#PackageSubcription has fields
# 1. tentative deadline for pre-production (for photo, it means the image selection)
# 2. Actual preproduction Finish date
# 3. Production tentative deadline
# 4. Actual Production Finish Date
# 5. Tentative Package Deadline Date
# 6. Actual Package  Finish Date

# Project has_many :packages through :package_subcription
# PackageSubcription has_many :deliverables through :deliverable_subcription 

#deliverable_subcription has 3 status
# 1. started  # if it is outsourced, it means PO has been given to the supplier , if it is inhouse, production has started
# 2. done     # if it 
# 3. delivered



# latest question: 1 project 1 package. or multiple project multiple package?
# i prefer the 1 project 1 package. If the client is getting multiple project + negotiation price, how? 
# 1 SalesOrder, multiple project. each project => linked to 1 package. that's it.  HAhaha. team has to be assembled for each project. 
# 1 SalesOrder, 1 price for all the packages selected . 


=begin
  POST PRODUCTION 
=end

# start deliverable, send to supplier 
photo_project.deliverable_items.each do |deliverable|
  deliverable.start_production(account_executive)
end

photo_project.reload!
photo_project.deliverable_items.each do |deliverable|
  deliverable.approve_finish_production(account_executive)
end

photo_project.reload!
photo_project.deliverable_items.each do |deliverable|
  deliverable.deliver_to_client(account_executive)
end

photo_project.finish_project( project_manager )
