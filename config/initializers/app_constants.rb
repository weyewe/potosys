COMPANY_NAME = "Little Collins"

=begin
  MODEL CONSTANT
=end

USER_ROLE = {
  :admin => "Admin",
  :photographer => "Photographer",
  
  # Marketing Team: composed of several marketers  + several marketing head
  #   marketing will add client to crm, add contact report, 
  #   deal with package selection
  #   and its modification
  #   select the photographer 
  #   select the date
  :marketing_head => "MarketingHead",
  :marketing => "Marketing", 
  
  # Graphic Team: composed of several graphic heads + several graphic editor 
  # it will create revision: video and pics
  :graphic_head => "GraphicHead",
  :graphic => "Graphic",
  
  # Project Management Team: 
  # oversee the whole development
  # controlling the deadline etc 
  :project_management_head => "ProjectManagementHead",
  :project_management => "ProjectManagement",
  
  # AccountExecutive deals with the communication to clients
  :account_executive => "AccountExecutive",
}

PROJECT_ROLE = {
  :account_executive => "AccountExecutive",
  :graphic => "Graphic",
  :project_manager => "ProjectManager",
  :photographer => "Photographer"
}

ARTICLE_PICTURE_TYPE = {
  :migrated_from_project => 1 ,
  :pure_article_upload => 2 
}

ARTICLE_TYPE = {
  :mapped_from_project => 1 , 
  :independent_article =>  2
}
=begin
  CONSTANT for AJAX
=end
TRUE_CHECK = 1
FALSE_CHECK = 0

PROPOSER_ROLE = 0 
APPROVER_ROLE = 1





=begin
  UTILITY ASSETs
=end
AVATAR_IMAGE = "https://s3.amazonaws.com/potoschool_icon/default_profile_pic.jpg"
TRANSLOADIT_UPLOAD_URL = "http://api2.transloadit.com/assemblies"
UPLOADIFY_SWF_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify.swf"
UPLOADIFY_CANCEL_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify-cancel.png"
UPLOADIFIVE_CANCEL_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify-cancel.png"
PRELOADER_URL = "http://s3.amazonaws.com/circle-static-assets/ajax-loader.gif"


=begin
  DISPLAY RELATED
=end
INDEPENDENT_ARTICLE_VALUE = 0 
ARTICLE_FROM_PROJECT_VALUE =  1 

FRONT_PAGE_WIDTH = 325
ARTICLE_WIDTH = 800

S3_BUCKET_BLOG_DEV  = 'nomina-dev'
S3_BUCKET_BLOG_PROD = 'nomina-prod'


