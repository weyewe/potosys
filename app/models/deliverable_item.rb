class DeliverableItem < ActiveRecord::Base
  attr_accessible :deliverable_id, :sub_item_quantity, :project_specific_description
  belongs_to :project 
  belongs_to :deliverable 
  
  has_one :purchase_order
  validates_presence_of :supplier_id, :estimated_finish_date, :total_transaction_amount, :deliverable_item_id, :creator_id 
  
  def create_or_update_purchase_order(employee,  purchase_order_params  )
    purchase_order = self.purchase_order
    if purchase_order.nil?
      purchase_order = PurchaseOrder.new 
    end

      
    if not employee.has_role?(:post_production) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:post_production] ) )
      purchase_order.errors.add(  :authentication , "No such role")
      return purchase_order
    end
    
    project = self.project
    if project.is_finished == true 
      return nil 
    end
    
    estimated_ending_date = Project.extract_event_date(purchase_order_params[:estimated_finish_date])
    if estimated_ending_date < project.project_start_date 
      purchase_order.errors.add(  :estimated_finish_date , 
                "Can't be earlier than project start date: #{project.project_start_date}")
      return purchase_order
    end
    
    total_transaction_amount = DeliverableItem.parse_price( purchase_order_params[:total_transaction_amount])
    if total_transaction_amount.nil?  or total_transaction_amount< BigDecimal("0")
      purchase_order.errors.add(  :total_transaction_amount , 
                "Can't be less than: 0 ")
      return purchase_order
    end
    
    purchase_order.estimated_ending_date = estimated_ending_date
    purchase_order.supplier_id = purchase_order_params[:supplier_id]
    purchase_order.deliverable_item_id = self.id 
    purchase_order.creator_id = employee.id 
    purchase_order.total_transaction_amount = total_transaction_amount
    purchase_order.note = purchase_order_params[:note]
    purchase_order.save
    
    return purchase_order  
  end
end
