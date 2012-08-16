class ProjectAssignment < ActiveRecord::Base
  attr_accessible :project_membership_id, :project_role_id
  belongs_to :project_role
  belongs_to :project_membership 
end
