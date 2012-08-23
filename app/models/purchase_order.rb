class PurchaseOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :deliverable_item 
  belongs_to :supplier 
end
