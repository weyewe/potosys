class ProjectAssignment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :project_role
  belongs_to :project_membership 
end
