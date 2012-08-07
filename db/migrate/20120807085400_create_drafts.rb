class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|

      t.timestamps
    end
  end
end
