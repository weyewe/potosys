class ProjectMembership < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :project
  
  has_many :project_assignments 
  has_many :project_roles, :through => :project_assignments
end
