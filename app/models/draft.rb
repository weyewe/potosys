class Draft < ActiveRecord::Base
  attr_accessible :overall_feedback, :proposed_deadline_date
  belongs_to :project 
  has_many :tasks
  validates_presence_of :overall_feedback, :proposed_deadline_date 
  
  def set_granted_deadline_date( employee, deadline_date ) 
    # if employee is not a member of this project, or wrong role 
    
    if deadline_date.nil? or deadline_date < self.project.project_start_date 
      self.errors.add(  :granted_deadline_date , "Date must not be nil" +  " and " + 
                        "it must not be earlier than the project start date")
                        
      return nil 
    end
    
    self.granted_deadline_date = deadline_date 
    self.save 
    past_job_requests = self.draft_creation_deadline_job_request
    if past_job_requests.count == 0 
      self.create_job_request (employee)
    else                      
      self.update_job_request( deadline_date)
    end
  end
  
  def draft_creation_deadline_job_request
    JobRequest.where(:job_request_source => JOB_REQUEST_SOURCE[:production_scheduling],
    :source_id => self.id , 
    :project_id => self.project_id , 
    :is_canceled => false  ) 
  end
  
  def create_job_request(employee)
    self.project.production_team.each do |project_membership|
      job_request = JobRequest.new  
      job_request.source_id = self.id
      job_request.project_id = self.project_id 
      job_request.user_id = project_membership.user_id 
      job_request.office_id = employee.active_job_attachment.office_id 
      
      job_request.job_request_source =  JOB_REQUEST_SOURCE[:production_scheduling]
      job_request.title = "Draft #{self.number} -- Project: #{self.project.title}"
      job_request.description = "#{self.overall_feedback}"


      job_request.starting_date = Time.now.to_date 
      job_request.ending_date = self.granted_deadline_date
      job_request.save
    end
  end
  
  def update_job_request( deadline_date )
    self.project.production_team.each do |project_membership|
      job_request = JobRequest.where(:job_request_source => JOB_REQUEST_SOURCE[:production_scheduling], 
        :source_id => self.id , 
        :user_id => project_membership.user_id 
      ).first 
      
      job_request.ending_date = deadline_date
      job_request.save 
    end
  end
  
  
=begin
  CREATE TASK 
=end

  def create_task( employee, task_params ) 
    new_task = Task.new( task_params)
    
    if not employee.has_role?(:account_executive) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:account_executive] ) )
     return nil
    end
    
    new_task.draft_id = self.id 
    new_task.save
    return new_task 
  end
  
=begin
  Finishing the draft
=end

  def finish_draft(employee, draft_finish_date ) 
    return nil if draft_finish_date.nil?  
    if not employee.has_role?(:account_executive) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:account_executive] ) )
     return nil
    end
    
    if  draft_finish_date < self.project.project_start_date  
      return nil
    end
    
    self.is_finished = true 
    self.finish_date  = draft_finish_date
    self.finisher_id = employee.id
    self.save 
  end
  
  def cancel_finish_draft( employee )
    if not employee.has_role?(:account_executive) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:account_executive] ) )
     return nil
    end 
    
    if self.project.is_production_finished == true 
      return nil
    end
    
    self.is_finished = false  
    self.finish_date  = nil 
    self.finisher_id = employee.id
    self.save
  end
  
end
