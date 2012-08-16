class ProjectRole < ActiveRecord::Base
  attr_accessible :name 
  has_many :project_assignments
  has_many :projects, :through => :project_assignments
end
