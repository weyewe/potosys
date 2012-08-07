class CreateDeliverableSubcriptions < ActiveRecord::Migration
  def change
    create_table :deliverable_subcriptions do |t|

      t.timestamps
    end
  end
end
