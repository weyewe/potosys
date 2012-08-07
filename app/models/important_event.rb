class ImportantEvent < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :client 
end
