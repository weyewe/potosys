class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.integer :creator_id 
      t.integer :client_id 
      
      t.decimal :total_transaction_amount , :default => 0, :precision => 11, :scale => 2 # 10^7 == 1000 million ( max value ) 
      
      
      t.timestamps
    end
  end
end
