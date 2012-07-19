puts "Photography Studio Management: potosys"

puts "\n*********APPLICATION WIDE SETUP*********\n"
puts "creating roles"
admin_role = Role.create :name => USER_ROLE[:admin]
photographer_role = Role.create :name => USER_ROLE[:photographer]
marketing_head_role   = Role.create :name => USER_ROLE[:marketing_head]
marketing_role   = Role.create :name => USER_ROLE[:marketing]
graphic_head_role = Role.create :name => USER_ROLE[:graphic_head]
graphic_role = Role.create :name => USER_ROLE[:graphic]
project_management_head_role = Role.create :name => USER_ROLE[:project_management_head]
project_management_role = Role.create :name => USER_ROLE[:project_management]
account_executive_role = Role.create :name => USER_ROLE[:account_executive]
publisher_role = Role.create :name => USER_ROLE[:publisher]


puts "*********OFFICE WIDE SETUP***********"
puts "creating office"
office = Office.create :name => COMPANY_NAME


puts "creating user"
publisher = office.create_main_user( [publisher_role], 
                  :email => 'publisher@gmail.com',
                  :password => 'willy1234',
                  :password_confirmation => 'willy1234'  )
