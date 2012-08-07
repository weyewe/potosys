class ProjectRole < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :project_assignments
  has_many :projects, :through => :project_assignments
end
