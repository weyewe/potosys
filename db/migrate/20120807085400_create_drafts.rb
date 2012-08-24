class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.text :overall_feedback 
      t.integer :number
      t.integer :creator_id # who created this draft? 
      
      t.date :start_draft_date 
      t.date :proposed_deadline_date  # when the deadline is ? 
      t.integer :deadline_proposer_id
      
      t.date :granted_deadline_date  # project manager has the final say of the deadline
      t.integer :deadline_grantor_id 
      
      # we DON'T USE ACTUAL_DEADLINE_DATE
      t.date :actual_deadline_date   # when account manager verify that the working date is cleared 
      t.integer :actual_deadline_approver_id  
      
      t.integer :project_id 
      
      t.boolean :is_finished  , :default => false 
      t.date :finish_date 
      t.integer :finisher_id  # the account executive declares that it is finish
      
      
      # then, it is the client part 

      t.timestamps
    end
  end
end
