class SalesOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :projects 
  belongs_to :client 
end
