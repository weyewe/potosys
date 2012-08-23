class ProjectMembership < ActiveRecord::Base
  attr_accessible :user_id, :project_id
  belongs_to :user
  belongs_to :project
  
  has_many :project_assignments 
  has_many :project_roles, :through => :project_assignments
  
  
  def has_role?(role_sym)
    project_roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  
  def has_project_role?(role_sym)
    has_role?(role_sym)
  end
  
  def has_assigned_project_role?(project_role)
    self.project_roles.map{|x| x.id}.include?(project_role.id )
  end
  
 
  
  
  def add_roles( project_role_array )
    project_role_array.each do |project_role|
      add_role_if_not_exist(  project_role.id )
    end
  end
  
  
  
  def add_role_if_not_exist(role_id)
    result = ProjectAssignment.find(:all, :conditions => {
      :project_membership_id => self.id,
      :project_role_id => role_id
    })
    
    if result.size == 0 
      ProjectAssignment.create :project_membership_id => self.id, :project_role_id => role_id
    end
    
    # does the shite inherit the past job_requests? I think so.... 
    # how does it work? for now, cancel it. 
    
  end
  
  def remove_project_role( project_role ) 
    project_role_assignments = ProjectAssignment.find(:all, :conditions => {
      :project_membership_id => self.id,
      :project_role_id => project_role.id
    })
    
    if project_role_assignments.size == 0
      return nil
    else
      project_role_assignments.each do |project_role_assignment|
        project_role_assignment.destroy 
      end
    end
    
    # if there is no other role attached to this project membership, just destroy the project membership
    if self.project_assignments.size == 0
      self.destroy 
    end
    
    
  end
  
  
end
