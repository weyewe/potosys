class Package < ActiveRecord::Base
  attr_accessible :name, :description,  :base_price , :number_of_crew, :is_crew_specific_pricing
  has_many :projects
  has_many :deliverable_subcriptions
  has_many :deliverables, :through => :deliverable_subcriptions 
  
  
  belongs_to :office 
  
  validates_numericality_of :number_of_crew, :base_price 
  validates_presence_of :is_crew_specific_pricing
  
  
end
