class DeliverableItem < ActiveRecord::Base
  attr_accessible :deliverable_id, :sub_item_quantity, :project_specific_description
  belongs_to :project 
  belongs_to :deliverable 
end
