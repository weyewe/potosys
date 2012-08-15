class CreateJobRequests < ActiveRecord::Migration
  def change
    create_table :job_requests do |t| 
      t.integer :source_id  
      t.string :source_type   
      
      t.string :title
      t.text :description 
      
      t.integer :user_id
      t.integer :job_request_source, :default => JOB_REQUEST_SOURCE[:crew_booking] # it can be from project booking , it can be draft assignment , it can be deadline 
      # draft revision
      
      t.date :starting_date 
      t.date :ending_date 
      t.integer :number_of_days
      
      t.integer :yday
      t.integer :year 

      t.timestamps
    end
  end
end
