class Client < ActiveRecord::Base
  attr_accessible :name, :address, 
                :mobile, :home_phone ,
                :bb_pin, :email
  belongs_to :office
  has_many :contact_reports 
  has_many :important_events 
  has_many :sales_orders 
  
  validates_presence_of :name 
  
  
  def creator
    User.find_by_id self.creator_id 
  end
  
  
  def unconfirmed_sales_orders( office ) 
    SalesOrder.where(:office_id => office.id, :is_confirmed => false, :is_canceled => false  )
  end
  
  def cancelled_sales_orders(office)
    SalesOrder.where(:office_id => office.id,  :is_canceled => true  )
  end
  
  
  def has_unconfirmed_sales_order?(office)
    unconfirmed_sales_orders( office ) .count != 0 
    
    # do the shit for packages_controller#select_package_for_single_package_sales_order
    # projects_controller#select_crew_to_be_booked
    #projects_controller#book_crew_for_single_package_sales_order
  end
  
  def pending_sales_order_confirmation(office)
    unconfirmed_sales_orders( office ).first 
  end
  
end
