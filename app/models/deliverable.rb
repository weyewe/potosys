class Deliverable < ActiveRecord::Base
  attr_accessible :name, :description, :sub_item_quantity, :independent_price, 
            :has_sub_quantity, :office_id, :has_sub_item, :sub_item_name, :independent_sub_item_price
  belongs_to :office
  
  has_many :packages, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
  
  has_many :projects, :through => :deliverable_items
  has_many :deliverable_items
  
  
  validates_presence_of :name 
  
  def set_office(office)
    self.office_id = office.id
    self.save 
  end
  
  
  def self.valid_price_string?(price_string)
    not self.parse_price(price_string).nil? 
    
    parsed_price = self.parse_price(price_string)
    if parsed_price.nil?
      return false
    else
      return true 
    end
  end
  
  def self.parse_price(price_string )
    begin
      Float(price_string)
    rescue
      return nil 
    end
    zero_value = BigDecimal("0")
    price = BigDecimal(price_string)
    
    if price >= zero_value 
      return price
    else
      return nil
    end
  end
  
  def self.is_numeric?(obj) 
     obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
  
  
end
