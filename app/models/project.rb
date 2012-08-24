class Project < ActiveRecord::Base
  attr_accessible :title, :shoot_date, :starting_date,  :ending_date, :shoot_location, :project_guideline 
  belongs_to :package
  has_many :deliverables, :through => :deliverable_items
  has_many :deliverable_items
  
  has_many :drafts
  
  has_many :project_memberships 
  has_many :users, :through => :project_memberships
  belongs_to :sales_order
  belongs_to :office
  
  has_many :job_requests
  
  validates_presence_of :title, :shoot_date, :starting_date, :ending_date , :shoot_location 
  after_create :assign_deliverable_items, :create_corresponding_sales_order
  
  def Project.create_single_package_project( employee , client, package, selected_pro_crew,  project_params )
    
     project = Project.new project_params
    
    if not (employee.has_role?(:marketing) or employee.has_role?(:marketing_head) )
      puts "88888 employee wrong role"
      project.errors.add(  :authentication , "Wrong Role: No admin role")
      return project
    end
    
    
    if package.is_crew_specific_pricing == true and not package.users.map{|x| x.id}.include?(selected_pro_crew.id)
      return nil
    end
    
    office = employee.active_job_attachment.office
    if not ( client.office_id ==  office.id  or package.office_id == office.id) 
      puts "111111 wrong office"
      project.errors.add(  :authentication , "Wrong Role: Different Office")
      return project
    end
    
    project.selected_pro_crew_id =selected_pro_crew.id
     
    shoot_date = Project.extract_event_date(project_params[:shoot_date])
    starting_date = Project.extract_event_date(project_params[:starting_date])
    ending_date = Project.extract_event_date(project_params[:ending_date])
    
    
    if not(  starting_date.nil? or shoot_date.nil? or ending_date.nil? ) and 
          ( starting_date <= shoot_date  and  shoot_date <= ending_date  and starting_date<= ending_date) and 
           selected_pro_crew.is_available_for_booking?( starting_date, ending_date, office )
          # and the crew assigned is free on that date
        # if the dates are OK 
      
      
      project.shoot_date = shoot_date
      project.starting_date = starting_date
      project.ending_date = ending_date
      
      project.client_id = client.id 
      project.package_id = package.id 
      project.creator_id = employee.id 
      project.office_id = office.id 
      project.save

      project.create_project_membership_assignment_for_selected_pro_crew 
      project.create_corresponding_job_request_for_crew_specific_pricing 
      
      return project
    else
      
      if not selected_pro_crew.is_available_for_booking?( starting_date, ending_date, office )
        selected_pro_crew.job_requests_between( starting_date, ending_date , office).each do |job_request|
          project.errors.add(  :booking_date_crashed , "The slot between #{job_request.starting_date} and #{job_request.ending_date} is booked")
        end
        return project 
      end
      
      if starting_date > shoot_date 
        puts "234 error 1"
        project.errors.add(  :starting_date , "Starting date has to be earlier than or equal  shoot date")
      end
    
      if shoot_date > ending_date
        puts "123 error 2"
        project.errors.add(  :ending_date , "Ending date has to be later than or equal  shoot date")
      end
      
      if starting_date > ending_date
        puts "32423 error 3"
        project.errors.add(  :starting_date , "Starting date has to be earlier than or equal  ending date")
      end
      
      puts "333333 no date params"
      project.save
      return project
    end
  end
  
=begin
  ADD EXTRA DELIVERABLE ITEM
=end

  def add_deliverable_item(employee, deliverable_item_params )
    deliverable_item = DeliverableItem.new deliverable_item_params 
    if not(employee.has_role?(:marketing) or employee.has_role?(:marketing_head) ) 
      deliverable_item.errors.add(  :authentication , "Wrong Role: No admin role")
      return deliverable_item
    end
    
    office = employee.active_job_attachment.office 
    deliverable = Deliverable.find_by_id deliverable_item_params[:deliverable_id]
    if not office.deliverables.map{|x| x.id}.include?(deliverable.id ) 
      deliverable_item.errors.add(  :deliverable_id , "Not Available in the office")
      return deliverable_item
    end
    
    if deliverable.has_sub_item == true 
      if deliverable_item_params[:sub_item_quantity].nil? or   
          deliverable_item_params[:sub_item_quantity].length == 0 or 
          deliverable_item_params[:sub_item_quantity].to_i <= 0 
        deliverable_item.errors.add(  :sub_item_quantity , "The item quantity can't be blank or less than 0")
        return deliverable_item
      end
    else
      deliverable_item.sub_item_quantity = nil
    end
    
    deliverable_item.project_id = self.id 
    deliverable_item.save 
    
    return deliverable_item 
    
    
    
    
  end
  
  
  def assign_deliverable_items
    # t.integer  "default_sub_item_quantity"
    # t.integer  "final_sub_item_quantity"
    # t.text     "project_specific_description"
    self.package.deliverable_subcriptions.each do |deliverable_subcription|
      self.deliverable_items.create(:deliverable_id => deliverable_subcription.deliverable_id, 
                :sub_item_quantity => deliverable_subcription.package_specific_sub_item_quantity,
                :project_specific_description => deliverable_subcription.deliverable.description
              )
    end
    
  end
  
  def  create_corresponding_sales_order 
    if not self.sales_order_id.nil?
      return nil
    end
    
    sales_order = SalesOrder.new
    sales_order.creator_id = self.creator_id 
    sales_order.client_id = self.client_id 
    sales_order.office_id = self.creator.active_job_attachment.office_id  
    sales_order.title = self.title
    sales_order.description = self.project_guideline
    sales_order.save 
    
    self.sales_order_id = sales_order.id 
    self.save
  end
  
  def project_price
    if self.package.is_crew_specific_pricing == true 
      PackageAssignment.where(:user_id => self.selected_pro_crew_id, 
                  :package_id => self.package_id).first.price
    else
      return project.base_price 
    end
  end
  
  
=begin
  ASSIGNING PROJECT MEMBERSHIP 
=end
  def add_project_membership( employee,  project_collaborator,  project_role, is_selected_pro_crew  )
    if not is_selected_pro_crew and not employee.has_role?(:project_manager_head)
      return nil
    end
    
    project_membership = ProjectMembership.find(:first, :conditions => {
      :user_id => project_collaborator.id ,
      :project_id => self.id
    })
    
    if project_membership.nil?
      project_membership = ProjectMembership.create(
                      :user_id => project_collaborator.id ,
                      :project_id => self.id 
                  )
    end
                
    project_membership.add_roles( [project_role] )
  end
  
  def remove_project_membership(employee, project_collaborator,  project_role  )
    if not employee.has_role?(:project_manager_head)
      return nil
    end
    
    project_membership = ProjectMembership.find(:first, :conditions => {
      :user_id => project_collaborator.id ,
      :project_id => self.id
    })
    
    if project_membership.nil?
      return nil
    end
    
    if not ( project_role.name == PROJECT_ROLE[:crew] and 
            project_collaborator.id == self.selected_pro_crew_id ) 
      project_membership.remove_project_role( project_role ) 
    end
    
    
    
  end
  
  def project_memberships_for_project_role( project_role )
    project_membership_id_list =  self.project_memberships.map{|x| x.id }
    
    ProjectAssignment.where(:project_role_id => project_role.id, 
            :project_membership_id => project_membership_id_list)
   
  end
  
=begin
  start project
=end
 
  def can_be_started?
    #  if all core project role has been assigned employee 
    ProjectRole.all.each do |project_role|
      if self.project_memberships_for_project_role( project_role ).count == 0 
        return false
      end
    end
    
    return true 
  end
  
  
  def start_project(employee)
    if not employee.has_role?(:project_manager_head)
      return nil
    end
    
    office = employee.active_job_attachment.office
    if office.id != self.office_id 
      return nil
    end
    
    self.is_started = true
    self.project_start_date = DateTime.now.to_date 
    self.save 
    
  end
  
  
  


=begin
  AFTER CREATE CALLBACK
=end
  def create_project_membership_assignment_for_selected_pro_crew
    if self.package.is_crew_specific_pricing == false
      return nil
    end
    
    self.add_project_membership( self.creator,  self.selected_pro_crew , ProjectRole.find_by_name( PROJECT_ROLE[:crew] ) , true ) 
  end
  
  def create_corresponding_job_request_for_crew_specific_pricing
    job_request =  self.job_requests.new 
    job_request.starting_date      = self.starting_date 
    job_request.ending_date        = self.ending_date
    job_request.job_request_source = JOB_REQUEST_SOURCE[:crew_booking]
    job_request.office_id          = self.sales_order.office_id 
    job_request.user_id            = self.selected_pro_crew_id 
    job_request.title              = "#{self.title}, location: #{self.shoot_location}"
    job_request.number_of_days     = (ending_date-starting_date).numerator
    job_request.year               = starting_date.year
    job_request.yday               = starting_date.yday 
    job_request.save 
  end
  
  
=begin
  ON CANCELATIOn 
=end
  def cancel_associated_job_requests(employee)
    self.job_requests.each do |job_request|
      job_request.is_canceled = true 
      job_request.canceller_id = employee.id
      job_request.save 
    end
  end

=begin
  UTILITY METHODS 
=end
  def self.extract_event_date(params_deadline_datetime)
    if params_deadline_datetime.nil? or params_deadline_datetime.length == 0 
      return nil
    end
    
    time_array = params_deadline_datetime.split("/")
    begin
      Date.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i) 
    rescue 
      return nil 
    end
  end
  
  def creator
    User.find_by_id self.creator_id 
  end
  
  def selected_pro_crew
    User.find_by_id self.selected_pro_crew_id
  end
  
=begin
  DRAFTS
=end
  def last_draft
    self.drafts.order("created_at DESC").first 
  end
  
  def create_draft( employee, draft_params ) 
    draft = Draft.new draft_params
    
    if not self.last_draft.nil?  and self.last_draft.is_finished == false
      draft.errors.add(  :authentication , "Past Draft is not finalized")
      return draft
    end
    
      
    if not employee.has_role?(:account_executive) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:account_executive] ) )
     draft.errors.add(  :authentication , "Wrong Role: No admin role")
     return draft
    end
    
    
    
    if not self.last_draft.nil?
      draft.number = self.last_draft.number +  1 
    else
      draft.number = 1 
    end
    
    draft.proposed_deadline_date =  Project.extract_event_date(draft_params[:proposed_deadline_date])
    
    
    draft.deadline_proposer_id = employee.id 
    draft.project_id = self.id 
    
    draft.save 
    return draft
  end
  
=begin
  Creating Draft Deadline
=end
  def production_team
    production_project_role_id_list = ProjectRole.where( :name => PROJECT_ROLE[:graphic_designer] ).map{|x| x.id }
    self.project_memberships.
        joins(:project_assignments).where( 
          :project_assignments => { :project_role_id => production_project_role_id_list}
        )
  end
  
  def production_team_job_requests
    
    production_team_user_id_list = self.production_team.map{|x| x.user_id }
    project_start_date = self.project_start_date
   
    self.job_requests.where{
     (user_id.in production_team_user_id_list) & 
       (ending_date.gte  project_start_date) & 
       (job_request_source.eq JOB_REQUEST_SOURCE[:production_scheduling] ) & 
       (is_canceled.eq false)
    }
  end
  
=begin
  Finalize the production
=end
  def finalize_production( employee, finalization_date ) 
    return nil if finalization_date.nil?  
    if not employee.has_role?(:account_executive) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:account_executive] ) )
     return nil
    end
    
    if finalization_date < self.project_start_date
      return nil
    end
    
    if self.drafts.where(:is_finished => false).count != 0
      return nil
    end
    
    self.is_production_finished = true 
    self.production_finish_date = finalization_date
    self.production_finisher_id = employee.id
    self.save 
    
  end
  
  def cancel_production_finalization(employee)
    if not employee.has_role?(:account_executive) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:account_executive] ) )
     return nil
    end
    
    self.is_production_finished = false
    self.production_finisher_id = employee.id 
    self.save 
  end

=begin
  POST PRODUCTION MANAGEMENT
=end
  def started_deliverables
    self.deliverable_items.where(:is_started => true )
  end
  
  def finished_deliverables
    self.deliverable_items.where(:is_finished => true )
  end
  
  def delivered_deliverables
    self.deliverable_items.where(:is_delivered => true )
  end
  
  def post_production_scheduling_job_requests 
    job_requests = self.job_requests.where(
      :job_request_source => JOB_REQUEST_SOURCE[:post_production_scheduling],
      :is_canceled => false  
    ) 
       #  
       # if job_request.nil? 
       #   return self.job_requests.new  
       # else
       #   return job_request
       # end
    return job_requests 
  end
  
  def create_or_update_post_production_job_request(employee, job_request_params) 
    job_request = self.post_production_scheduling_job_requests.first 
    if job_request.nil?
      job_request = self.job_requests.new
    end
    
    if not employee.has_role?(:project_manager) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:project_manager] ) )
     job_request.errors.add(  :authentication , "No such role")
     return job_request
    end
    
    starting_date = Project.extract_event_date(job_request_params[:starting_date])
    ending_date   = Project.extract_event_date(job_request_params[:ending_date])
    
    if starting_date > ending_date  or
        starting_date.nil? or ending_date.nil?
      job_request.errors.add(  :starting_date , "Starting Date must not be later than ending date")
      return job_request
    end
     
     
    if post_production_team_job_requests.count == 0 
      self.create_post_production_job_request(starting_date, ending_date)
    else                      
      self.update_post_production_job_request(starting_date, ending_date)
    end
    
     
    return job_request
  end
  
  def create_post_production_job_request(starting_date, ending_date)
    self.post_production_team.each do |project_membership|
      job_request = JobRequest.new 
      job_request.project_id = self.id 
      job_request.title = "[#{self.title}] Post Production"
      job_request.starting_date = starting_date
      job_request.ending_date = ending_date 
      job_request.job_request_source =  JOB_REQUEST_SOURCE[:post_production_scheduling]
      job_request.user_id = project_membership.user_id 
      job_request.save
    end 
  end
  
  def update_post_production_job_request(starting_date, ending_date)
    self.post_production_team_job_requests.each do |job_request|
      job_request.starting_date = starting_date
      job_request.ending_date = ending_date 
      job_request.save 
    end
  end
  
  def post_production_team
    production_project_role_id_list = ProjectRole.where( :name => PROJECT_ROLE[:post_production] ).map{|x| x.id }
    self.project_memberships.
        joins(:project_assignments).where( 
          :project_assignments => { :project_role_id => production_project_role_id_list}
        )
  end
  
  def post_production_team_job_requests
    
    post_production_team_user_id_list = self.post_production_team.map{|x| x.user_id }
    project_start_date = self.project_start_date
   
    self.job_requests.where{
     (user_id.in post_production_team_user_id_list) & 
       (ending_date.gte  project_start_date) & 
       (job_request_source.eq  JOB_REQUEST_SOURCE[:post_production_scheduling]) & 
       (is_canceled.eq false)
    }
  end
  
=begin
  UTIL
=end
  def production_team_job_request_package 
    job_requests_package = {}
    self.production_team.each do |project_member|
      job_requests_package[project_member.user_id] = JobRequest.joins(:project).where(
            :user_id => project_member.user_id , :is_canceled => false ,
            :project => {:is_finished => false })
    end
    
    return job_requests_package
  end
  
end
