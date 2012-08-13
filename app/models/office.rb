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
    return user 
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
  MASTER DATA: Create Deliverable and Package
=end

  def create_deliverable( employee, deliverable_params)
    deliverable = Deliverable.new(deliverable_params)
    if not employee.has_role?(:admin)
      deliverable.errors.add(  :authentication , "Wrong Role: No admin role")
      return deliverable
    end
    
  
    
    if not ( deliverable_params[:has_sub_item].class == TrueClass or deliverable_params[:has_sub_item].class == FalseClass )
      if deliverable_params[:has_sub_item].to_i == TRUE_CHECK
        deliverable_params[:has_sub_item] = true
      else
        deliverable_params[:has_sub_item] = false
      end
    end
      
    # only validate the sub_item if it is declared as having sub item 
    if deliverable_params[:has_sub_item] == true 
      if not Deliverable.valid_price_string?(deliverable_params[:independent_price])
        deliverable.errors.add(  :independent_price , "Invalid Price")
      end
      
      if deliverable_params[:sub_item_name].nil? or deliverable_params[:sub_item_name].length == 0 
        deliverable.errors.add(  :sub_item_name , "Invalid Sub Item Name")
      end
      
      if  deliverable_params[:sub_item_quantity].nil? or 
          not Deliverable.is_numeric?( deliverable_params[:sub_item_quantity] ) or 
            deliverable_params[:sub_item_quantity].length == 0 
        deliverable.errors.add(  :sub_item_quantity , "Invalid Sub Item Quantity")
      end
      
       if not Deliverable.valid_price_string?(deliverable_params[:independent_sub_item_price])
          deliverable.errors.add(  :independent_sub_item_price , "Invalid Sub Item Price")
        end
      
      if deliverable.errors.messages.length != 0   
        return deliverable
      end
    end
    
    deliverable_params[:independent_price] = Deliverable.parse_price(deliverable_params[:independent_price] )  
      
    deliverable.update_attributes deliverable_params
    deliverable.office_id = self.id 
    deliverable.save 
    
    return deliverable 
    
    # check deliverable.persisted? 
    # check whether there is error 
    # result.errors.messages.length
  end
  
  def create_package( employee, package_params)
    package = Package.new(package_params)
    if not employee.has_role?(:admin)
      package.errors.add(  :authentication , "Wrong Role: No admin role")
      return package
    end
    
    #  cleaning up the boolean 
    if not ( package_params[:is_crew_specific_pricing].class == TrueClass or 
        package_params[:is_crew_specific_pricing].class == FalseClass  or 
        package_params[:is_crew_specific_pricing].nil?)
      if package_params[:is_crew_specific_pricing].to_i == TRUE_CHECK
        package_params[:is_crew_specific_pricing] = true
      else
        package_params[:is_crew_specific_pricing] = false
      end
    end
    
    package_params[:base_price] = Package.parse_price(package_params[:base_price] )  
    
    package.update_attributes package_params
    package.office_id = self.id 
    package.save
    
    
    return package 
    
  end
  
=begin
  PACKAGE ASSIGNMENT, selecting crew: videographer, photographer
=end

  def Office.crew_role_id_list
    Role.where(:name => [
        USER_ROLE[:pro_photographer],
        # USER_ROLE[:amateur_photographer],
        USER_ROLE[:pro_videographer]
        # USER_ROLE[:amateur_videographer]
      ]
    ).map{|x| x.id }
  end

  def crews
    #  select all users with company role: photographer (pro + amateur)
    # and videographer (pro + amateur) 
    
    # Category.includes(:posts => [{:comments => :guest}, :tags]).find(1)
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Office.crew_role_id_list }  } ).
            order("created_at DESC") 
  end
  
  
=begin
  Create CLIENT 
=end
  def create_client( employee, client_params)
    client = Client.new(client_params)
    if not ( employee.has_role?(:marketing) or employee.has_role?(:marketing_head) ) 
      client.errors.add(  :authentication , "Wrong Role: No admin role")
      return client
    end
    
    client.save 
    
    client.office_id = self.id 
    client.creator_id = employee.id 
    client.save
    
    return client 
  end
  
  def clients_created_by_employee( employee )
    self.clients.where(:creator_id => employee.id).order("created_at DESC")
  end
  
  
end
