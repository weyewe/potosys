class Client < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :office
  has_many :contact_reports 
  has_many :important_events 
end
