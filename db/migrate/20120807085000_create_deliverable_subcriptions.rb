class CreateDeliverableSubcriptions < ActiveRecord::Migration
  def change
    create_table :deliverable_subcriptions do |t|

      t.integer :package_id  
      t.integer :deliverable_id 
      t.integer :package_specific_sub_item_quantity  # different package, different default sub_item 
      
      
      t.timestamps
    end
  end
end
