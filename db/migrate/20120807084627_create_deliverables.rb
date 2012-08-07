class CreateDeliverables < ActiveRecord::Migration
  def change
    create_table :deliverables do |t|

      t.timestamps
    end
  end
end
