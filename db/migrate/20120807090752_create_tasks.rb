class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :description 
      t.integer :draft_id 
      
      t.boolean :is_deleted , :default => false 
      t.integer :deleter_id 
      t.timestamps
    end
  end
end
