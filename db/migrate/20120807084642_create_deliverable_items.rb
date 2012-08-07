class CreateDeliverableItems < ActiveRecord::Migration
  def change
    create_table :deliverable_items do |t|

      t.timestamps
    end
  end
end
