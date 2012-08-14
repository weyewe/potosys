class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :package_id 
      
      t.string  :title
      t.text :project_guideline
      
      t.date :shoot_date 
      t.date :ending_date  
      
      t.boolean :is_project_started, :default => false  # will be started when the sales order is confirmed 
      t.boolean :is_supply_finished , :default => false 
      t.boolean :is_pre_production_finished , :default => false 
      t.boolean :is_production_finished , :default => false 
      t.boolean :is_post_production_finished , :default => false 
      
      t.boolean :is_finished , :default => false
      
      
      
      
      
      t.timestamps
    end
  end
end
