class Deliverable < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :projects, :through => :deliverable_items
  has_many :deliverable_items
  
  has_many :packages, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
end
