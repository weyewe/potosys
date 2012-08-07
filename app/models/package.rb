class Package < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :projects
  has_many :deliverable_subcriptions
  has_many :deliverables, :through => :deliverable_subcriptions 
  
  belongs_to :office 
end
