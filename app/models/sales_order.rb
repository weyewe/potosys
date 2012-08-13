class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :projects 
  belongs_to :client 
  
  def creator
    User.find_by_id self.creator_id
  end
end
