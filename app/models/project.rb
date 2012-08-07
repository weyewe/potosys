class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :package
  has_many :deliverables, :through => :deliverable_items
  has_many :deliverable_items
  
  has_many :drafts
end
