class CreateDeliverables < ActiveRecord::Migration
  def change
    create_table :deliverables do |t|
      t.integer :office_id 
      t.string :name
      t.text :description 
      t.string :sub_item_name 
      t.boolean :has_sub_item , :default => false 
      t.integer :sub_item_quantity 
      
      t.decimal :independent_price , :default => 0, :precision => 11, :scale => 2 # 10^9 == 1000 million ( max value ) 
      t.decimal :independent_sub_item_price , :default => 0, :precision => 11, :scale => 2 # 10^9 == 1000 million ( max value ) 
      t.timestamps
    end
  end
end
