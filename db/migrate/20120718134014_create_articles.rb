class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title 
      t.string :sub_title 
      t.text :description
      t.text :teaser 
      t.integer :project_id 
      
      
      t.integer :office_id 
      t.integer :user_id 
      
      t.integer :article_type , :default => ARTICLE_TYPE[:mapped_from_project]
      
      t.boolean :has_front_page_image, :default => false 
      
      t.integer :article_category_id 
      
      t.boolean :is_deleted , :default => false
      
      t.datetime :publication_datetime, :datetime 
      
      t.boolean :is_displayed, :default => false 
      
      t.timestamps
    end
  end
end
