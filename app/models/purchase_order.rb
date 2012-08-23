class PurchaseOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :deliverable_item 
  belongs_to :supplier 
  
  after_create :start_deliverable_item 
  validates_presence_of :supplier_id, :estimated_finish_date, :total_transaction_amount, :deliverable_item_id, :creator_id 
  
  
  def start_deliverable_item
    deliverable_item = self.deliverable_item 
    
    deliverable_item.is_started = true 
    deliverable_item.starter_id = self.creator_id 
    deliverable_item.start_date = Time.now.to_date 
    deliverable_item.save 
  end
end
