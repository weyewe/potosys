class Project < ActiveRecord::Base
  attr_accessible :title, :shoot_date, :ending_date
  belongs_to :package
  has_many :deliverables, :through => :deliverable_items
  has_many :deliverable_items
  
  has_many :drafts
  
  has_many :project_memberships 
  has_many :users, :through => :project_memberships
  
  
  validates_presence_of :title, :shoot_date, :ending_date 
  
end
