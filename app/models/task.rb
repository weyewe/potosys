class Task < ActiveRecord::Base
  attr_accessible :description
  belongs_to :draft 
  
  validates_presence_of :description
end
