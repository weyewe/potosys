class JobRequest < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user 
  belongs_to :project
  belongs_to :office
  
  
=begin
  POST PRODUCTION 
=end

end
