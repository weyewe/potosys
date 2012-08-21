class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.integer :office_id 
      t.string :name 
      t.text :address
      t.string :office_phone
      t.string :email
      t.string :mobile
      
      
      t.string :contact_person_name 
      t.string :contact_person_bb_pin
      t.string :contact_person_email
      t.string :contact_person_mobile
      
      t.integer :creator_id 
      
      t.timestamps
    end
  end
end
