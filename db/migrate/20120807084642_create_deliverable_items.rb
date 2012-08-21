class CreateDeliverableItems < ActiveRecord::Migration
  def change
    create_table :deliverable_items do |t|
      t.integer :project_id 
      t.integer :deliverable_id 
      
      
      # perhaps, 1 album, 40 pics.. then, the client and marketing negotiated. Decided to ask for more sub item quantity. 
      # default_sub_item_quantity is inferred from the corresponding deliverable_subcription 
      #t.integer :default_sub_item_quantity  # can't be edited , migrated from deliverable subcription (package specific)
      #t.integer :final_sub_item_quantity  # edited
      # the difference == extra cost. if it is going to that direction. :)
      t.integer :sub_item_quantity
      t.text :project_specific_description 
      
      # t.boolean :is_extra_deliverable_item, :default => false 
      
      
      t.boolean :is_started , :default => false
      t.text :supplier_info # if it is outsourced
      t.integer :starter_id 
      t.date :start_date
      
      t.boolean :is_finished, :default => false 
      t.integer :finisher_id 
      t.date :finish_date 
      
      # when it is delivered, we have the proof of delivery from client. 
      t.boolean :is_delivered, :default => false 
      t.integer :deliverer_id 
      t.date :delivery_date 
      

      t.timestamps
    end
  end
end
