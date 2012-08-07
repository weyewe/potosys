class Office < ActiveRecord::Base
  attr_accessible :name
  has_many :packages
  has_many :deliverables 
  
  has_many :users, :through => :job_attachments 
  has_many :job_attachments
  
  has_many :clients 
  has_many :contact_reports 
  
  
  
  
  has_many :articles
  
=begin
  CREATING USER
=end
  def create_employee_by_email( email )
    user = User.create :email => email, :password => 'willy1234', 
      :password_confirmation => 'willy1234'

    if not user.valid? 
      return nil
    else
      JobAttachment.create(:office_id => self.id, :user_id => user.id)
      return user 
    end


  end

  def users
    User.joins(:job_attachments).where(
    :job_attachments => {
      :is_deleted => false,
      :office_id => self.id
    })
  end
  
  def main_user
    User.find_by_id self.main_user_id
  end
  
  def create_main_user(role_list, user_hash) 
    user = self.create_user(role_list, user_hash)
    self.main_user_id = user.id 
    self.save
  end
  
  def create_user(role_list, user_hash)
    new_user = User.new(user_hash)
    
    if not new_user.save
      return nil
    end
    
    job_attachment = JobAttachment.create(:user_id => new_user.id, :office_id => self.id)
    
    role_list.each do |role|
      Assignment.create_role_assignment_if_not_exists( role,  new_user)
    end
    
    return new_user 
  end
  
=begin
  BUSINESS LOGIC
=end

  
  
  
end
