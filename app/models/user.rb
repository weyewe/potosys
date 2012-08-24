class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :offices, :through => :job_attachments 
  has_many :job_attachments
  
  validates :email, :presence => true, :email => true
  
  has_many :contact_reports
  has_many :job_requests

=begin
  PACKAGE SPECIFIC 
=end
  
  has_many :package_assignments 
  has_many :packages, :through => :package_assignments 

=begin
  PROJECT SPECIFIC
=end
  has_many :project_memberships 
  has_many :projects, :through => :project_memberships
  
    
  def active_job_attachment
    self.job_attachments.where(:is_active => true).first
  end
  
  def active_office
    self.active_job_attachment.office 
  end
  
  def has_role?(role_sym)
    active_job_attachment.has_role?(role_sym)
  end
  
  def valid_role_updating_info?(office, employee)
    if not employee.has_role?(:admin)
      return false
    end
    
    job_attachment = JobAttachment.find(:first, :conditions => {
      :office_id =>office.id,
      :user_id => self.id
    })
    # is the executing employee is in the same office with the employee being executed?
    if employee.active_job_attachment.office_id != job_attachment.office_id 
      return false
    end
    
    return true
  end
  
  def add_role( role, office, employee)
    if not valid_role_updating_info?(office, employee)
      puts "invalid role updating info"
      return nil
    end
    
    job_attachment = JobAttachment.find(:first, :conditions => {
      :office_id =>office.id,
      :user_id => self.id
    })
    
    if job_attachment.roles.map{|x| x.id}.include?(role.id)
      return nil
    else
      # create the role assignment 
      Assignment.create(:job_attachment_id => job_attachment.id, 
      :role_id => role.id )
    end
  end
  
  def remove_role(role, office, employee)
    if not valid_role_updating_info?(office, employee)
      puts "not valid role updating info"
      return nil
    end
    
    job_attachment = JobAttachment.find(:first, :conditions => {
      :office_id =>office.id,
      :user_id => self.id
    })
    
    if job_attachment.roles.map{|x| x.id}.include?(role.id)
      if self.id == office.main_user_id && role.id == Role.find_by_name(USER_ROLE[:admin]).id
        puts "has the role id , but it is the main user"
        return nil
      end
      # destroy the role assignment 
      assignments = Assignment.find(:all, :conditions => {
        :role_id => role.id,
        :job_attachment_id => job_attachment.id 
      })
      assignments.each do |assignment|
        assignment.destroy
      end
      
    else
      puts "there is no mentioned role id"
      return nil
    end
    
  end
  
  
=begin
  CREATE BOOKING FOR CREW
=end
  def is_available_for_booking?( request_starting_date, request_ending_date , office)
    
    job_requests_between( request_starting_date, request_ending_date , office).count == 0  
            
  end
  
  def job_requests_between( request_starting_date, request_ending_date , office)
    self.job_requests.where{
      (job_request_source.eq JOB_REQUEST_SOURCE[:crew_booking]) & 
      (is_canceled.eq false) & 
      (office_id.eq office.id ) & 
      (starting_date.gte request_starting_date) & 
      (ending_date.lte request_ending_date) 
    }
  end
  
  def booked_job_requests(office)
    request_starting_date = DateTime.now.yesterday.to_date
    self.job_requests.where{
      (job_request_source.eq JOB_REQUEST_SOURCE[:crew_booking]) & 
      (is_canceled.eq false) & 
      (office_id.eq office.id ) & 
      (is_finished.eq false)
    }
  end
  
  
=begin
  PROJECT MEMBERSHIP ASSIGNMENT
=end

  def active_projects
    self.project_memberships.joins(:project).where(
      :project => { :is_canceled => false, :is_finished => false}
    )
  end
  
  def past_projects 
    self.project_memberships.joins(:project).where(
      :project => { :is_canceled => false, :is_finished => true}
    )
  end
  
  def project_membership_for(project)
    ProjectMembership.where(:user_id => self.id , :project_id => project.id ).first
  end
  
  def has_project_membership?(project)
    not project_membership_for(project).nil? 
  end
  
  def has_project_role?( project, project_role)
    self.has_project_membership?(project) and 
        self.project_membership_for(project).has_assigned_project_role?(project_role)
  end
  
  
  def assigned_projects_for( project_role )
    current_user = self
    project_role_object = ProjectRole.find_by_name project_role 
    Project.joins(:project_memberships => [:project_assignments] ).where( 
      :project_memberships => {:project_assignments => { :project_role_id =>project_role_object.id }} 
    ).where( :project_memberships => {:user_id => current_user.id} ,
    :is_started => true )
  end 
  
  


end
