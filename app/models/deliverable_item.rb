class DeliverableItem < ActiveRecord::Base
  attr_accessible :deliverable_id, :sub_item_quantity, :project_specific_description
  belongs_to :project 
  belongs_to :deliverable 
  
  has_one :purchase_order
  
  
  
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
    
    estimated_finish_date = Project.extract_event_date(purchase_order_params[:estimated_finish_date])
    if estimated_finish_date < project.project_start_date 
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
    
    purchase_order.estimated_finish_date = estimated_finish_date
    purchase_order.supplier_id = purchase_order_params[:supplier_id]
    purchase_order.deliverable_item_id = self.id 
    purchase_order.creator_id = employee.id 
    purchase_order.total_transaction_amount = total_transaction_amount
    purchase_order.start_note = purchase_order_params[:start_note]
    purchase_order.save
    
    
    
    return purchase_order  
  end
  
  def finish_creation( employee, purchase_order_params )
    
    actual_finish_date = Project.extract_event_date(purchase_order_params[:actual_finish_date])
    purchase_order = self.purchase_order 
    
    if not employee.has_role?(:post_production) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:post_production] ) )
      purchase_order.errors.add(  :authentication , "No such role")
      return purchase_order
    end
    
    if actual_finish_date.nil? or actual_finish_date < purchase_order.estimated_finish_date 
      purchase_order.errors.add(  :actual_finish_date , 
                "Can't be earlier than estimated finish date: #{purchase_order.estimated_finish_date}")
      return purchase_order
    end
    
    purchase_order.actual_finish_date = actual_finish_date
    purchase_order.finish_note = purchase_order_params[:finish_note]
    purchase_order.is_finished = true
    purchase_order.save 
     
    #  update the duplicate data @ deliverable_item 
    self.is_finished = true
    self.finisher_id = employee.id
    self.finish_date = actual_finish_date
    self.save 
    return purchase_order
  end
  
  
  def execute_delivery(employee, delivery_item_params)
    delivery_date  = Project.extract_event_date(delivery_item_params[:delivery_date]) 
    purchase_order = self.purchase_order 
    
    if not employee.has_role?(:post_production) or
       not employee.has_project_role?( self, ProjectRole.find_by_name( PROJECT_ROLE[:post_production] ) )
      self.errors.add(  :authentication , "No such role")
      return self
    end
    
    if delivery_date.nil? or delivery_date < purchase_order.actual_finish_date 
      self.errors.add(  :delivery_date , 
                "Can't be earlier than  finish date: #{purchase_order.actual_finish_date}")
      return self
    end
    
    self.delivery_date = delivery_date
    self.delivery_note = delivery_item_params[:delivery_note]
    self.is_delivered = true
    self.save  
    
    return self
    
  end
  
  def can_be_started?
    self.is_finished == false and self.is_delivered == false  
  end
  
  def can_be_finished?
    not self.purchase_order.nil? and  self.is_started == true and self.is_finished == false and self.is_delivered == false 
  end
  
  def can_be_delivered?
    not self.purchase_order.nil? and self.is_started == true and self.is_finished == true and self.is_delivered == false 
  end
  
=begin
  UTILITY, to show list of deliverable_items, classified as pending start, pending finish, pending delivery
=end

  def DeliverableItem.pending_start( current_user )
    project_list_id = current_user.assigned_projects_for( PROJECT_ROLE[:post_production] ) .map{|x| x.id }
    DeliverableItem.where(:project_id => project_list_id, 
    :is_started => false , 
    :is_finished => false, 
    :is_delivered => false ).order("created_at ASC")
  end
  
  def DeliverableItem.pending_finish( current_user )
    project_list_id = current_user.assigned_projects_for( PROJECT_ROLE[:post_production] ) .map{|x| x.id }
    DeliverableItem.where(:project_id => project_list_id, 
    :is_started => true , 
    :is_finished => false, 
    :is_delivered => false ).order("start_date ASC")
  end
  
  def DeliverableItem.pending_delivery( current_user )
    project_list_id = current_user.assigned_projects_for( PROJECT_ROLE[:post_production] ) .map{|x| x.id }
    DeliverableItem.where(:project_id => project_list_id, 
    :is_started => true , 
    :is_finished => true, 
    :is_delivered => false ).order("finish_date ASC")
  end
  
end
