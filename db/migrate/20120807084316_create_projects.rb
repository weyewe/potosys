class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :package_id 
      t.integer :sales_order_id
      
      t.string  :title
      t.text :project_guideline
      
      t.date :shoot_date 
      t.date :starting_date 
      t.date :ending_date  
      t.string :shoot_location
      
      t.boolean :is_started, :default => false  # will be started when the project membership assignment is finished
      t.date :project_start_date 
      
      
      t.boolean :is_supply_finished , :default => false 
      t.date :supply_finish_date 
      
      t.boolean :is_pre_production_finished , :default => false 
      t.date  :pre_production_finish_date 
      
      t.boolean :is_production_finished , :default => false 
      t.date :production_finish_date 
      
      t.boolean :is_post_production_finished , :default => false 
      t.date :post_production_finish_date 
      
      t.boolean :is_finished , :default => false
      t.date :finish_date 
      
      # how do we record the crew in crew_based_pricing 
      t.integer :selected_pro_crew_id
      t.integer :creator_id 
      t.integer :client_id  
      
      
      t.boolean :is_canceled, :default => false 
      t.integer :canceller_id 
    
    
      t.integer :office_id
      
      
      
      t.timestamps
    end
  end
end
