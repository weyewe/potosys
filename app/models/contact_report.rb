class ContactReport < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :client 
  belongs_to :user 
  belongs_to :office 
end
