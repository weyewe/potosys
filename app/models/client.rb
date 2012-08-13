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
end
