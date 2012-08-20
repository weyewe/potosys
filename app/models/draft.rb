class Draft < ActiveRecord::Base
  attr_accessible :overall_feedback, :proposed_deadline_date
  belongs_to :project 
  has_many :tasks
  validates_presence_of :overall_feedback, :proposed_deadline_date 
end
