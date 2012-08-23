class Supplier < ActiveRecord::Base
  attr_accessible  :name                 ,
                   :address              ,
                   :office_phone         ,
                   :email                ,
                   :mobile               ,
                   :contact_person_name  ,
                   :contact_person_bb_pin,
                   :contact_person_email ,
                   :contact_person_mobile 
                   
  belongs_to :office
  has_many :purchase_orders 
  
  validates_presence_of :office_id, :creator_id, :name 
end
