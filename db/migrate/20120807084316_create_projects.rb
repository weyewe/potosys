class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :package_id 
      
      t.string  :title
      t.text :project_guideline
      
      t.date :shoot_date 
      
      t.boolean :is_project_started, :default => false 
      
      
      
      t.timestamps
    end
  end
end
