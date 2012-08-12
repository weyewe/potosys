class CreatePackageAssignments < ActiveRecord::Migration
  def change
    create_table :package_assignments do |t|
      t.integer :user_id 
      t.integer :package_id 
      t.decimal :price , :default => 0, :precision => 11, :scale => 2 # 10^7 == 1000 million ( max value ) 
      # t.boolean :is_active , :default => true 
      
      t.timestamps
    end
  end
end
