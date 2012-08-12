class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :office_id
      t.string :name 
      t.text :description 
      t.decimal :base_price , :default => 0, :precision => 12, :scale => 2 # 10^10 == 10 000 million ( max value )
      
      t.boolean :is_crew_specific_pricing, :default => false 
      t.integer :number_of_crew, :default => 1 
      
      
      
      
      t.timestamps
    end
  end
end
