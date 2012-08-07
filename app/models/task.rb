class Task < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :draft 
end
