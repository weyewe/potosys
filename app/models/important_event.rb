# client's perspective 
# all clients have important event, whether it is bday, prewedding, etc

class ImportantEvent < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :client 
end
