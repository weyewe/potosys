class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :office_id 
      t.integer :creator_id 
      t.string :name
      t.text :address
      t.string :mobile
      t.string :home_phone
      t.string :bb_pin
      t.string :email 
      
 
      

      t.timestamps
    end
  end
end
