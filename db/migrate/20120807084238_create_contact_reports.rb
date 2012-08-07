class CreateContactReports < ActiveRecord::Migration
  def change
    create_table :contact_reports do |t|
      t.integer :office_id
      t.integer :user_id 
      t.integer :client_id 
      
      t.integer :project_id, :default => nil # when it is not nil, it is for the production follow up 
      t.integer :contact_purpose , :default => CONTACT_PURPOSE[:product_enquiry]  
      t.string :summary 
      t.text :description
      
      t.datetime :contact_datetime 
      # t.date :date_of_importance  # auto create reminder 1 month before the date of importance  
      

      t.timestamps
    end
  end
end
