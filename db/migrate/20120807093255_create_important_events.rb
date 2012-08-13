class CreateImportantEvents < ActiveRecord::Migration
  def change
    create_table :important_events do |t|
      t.date :event_date 
      t.string :title 
      t.text :description
      
      t.boolean :is_repeating_annually, :default => false 
      
      t.integer :creator_id # employee_id  
      t.integer :client_id
      t.integer :yday 
      
      
      t.timestamps
    end
  end
end
