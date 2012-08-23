class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :deliverable_item_id
      t.integer :supplier_id 
      
      t.decimal :total_transaction_amount , :default => 0, :precision => 11, :scale => 2 # 10^7 == 1000 million ( max value ) 
      t.text :start_note 
      t.date :estimated_finish_date 
    
      
      
      t.boolean :is_finished, :default => false 
      t.date :actual_finish_date
      t.text :finish_note 
      
      t.integer :creator_id  
      t.timestamps
    end
  end
end
