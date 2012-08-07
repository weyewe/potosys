class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :office_id
      t.string :title 
      t.text :description 
      
      t.decimal :independent_price , :default => 0, :precision => 12, :scale => 2 # 10^10 == 10 000 million ( max value ) 

      t.timestamps
    end
  end
end
