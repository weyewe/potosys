class Deliverable < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :office
  
  has_many :packages, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
  
  has_many :projects, :through => :deliverable_items
  has_many :deliverable_items
  
end
