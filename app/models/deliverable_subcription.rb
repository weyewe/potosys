class DeliverableSubcription < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :package 
  belongs_to :deliverable
end
