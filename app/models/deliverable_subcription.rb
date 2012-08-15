class DeliverableSubcription < ActiveRecord::Base
  attr_accessible :deliverable_id, :package_id, :package_specific_sub_item_quantity
  belongs_to :package 
  belongs_to :deliverable
end
