class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :projects 
  belongs_to :client 
  belongs_to :office
  
  def creator
    User.find_by_id self.creator_id
  end
  
  def confirm_sales_order(employee, sales_order_params)
    sales_order = self 
    office = employee.active_job_attachment.office 
    if office.id != self.office_id 
      return nil
    end
    
    if not (employee.has_role?(:marketing) or employee.has_role?(:marketing_head))
      sales_order.errors.add(  :authentication , "Wrong Role: No admin role")
      return sales_order
    end
    
    total_transaction_amount  = SalesOrder.parse_price(sales_order_params[:total_transaction_amount] )  
    
    if total_transaction_amount.nil? or total_transaction_amount <= BigDecimal("0")
      sales_order.errors.add(  :total_transaction_amount , "The Final  Negotiated AMOUNT  can't be less than or equal to 0")
      return sales_order
    end
    
    sales_order.total_transaction_amount = total_transaction_amount
    sales_order.save 
    
    sales_order.is_confirmed = true
    sales_order.confirmer_id = employee.id  
    sales_order.save
    
    return sales_order 
  end
  
  def cancel_single_package_sales_order(employee)
    if not (employee.has_role?(:marketing) or employee.has_role?(:marketing_head))
      return nil
    end
    
    if self.office_id != employee.active_job_attachment.office_id
      return nil
    end
    
    if self.is_confirmed == true 
      return nil
    end
    
    self.is_canceled =true
    self.canceller_id = employee.id 
    self.save
    
    self.cancel_associated_projects(employee)
  end
  
  def cancel_associated_projects(employee)
    self.projects.each do |project|
      project.is_canceled = true
      project.canceller_id = employee.id
      project.save
      project.cancel_associated_job_requests(employee)
    end
  end
  
  
  
  
end
