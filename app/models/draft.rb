class Draft < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :project 
  has_many :tasks
end
