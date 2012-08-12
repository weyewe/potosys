class PackageAssignment < ActiveRecord::Base
  attr_accessible :user_id, :package_id
  belongs_to :user
  belongs_to :package 
  
  
  def self.appropriate_user_for_package_assignment?(employee, package)
    if not employee.has_role?(:admin)
      return false
    end
    
    if employee.active_job_attachment.office_id != package.office_id
      return false
    end
    
    return true 
  end
  
  
end
