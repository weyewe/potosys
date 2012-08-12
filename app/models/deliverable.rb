NumberValidator
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
  
  
  
  
  
end
