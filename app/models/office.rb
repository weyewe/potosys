class Office < ActiveRecord::Base
  attr_accessible :name
  has_many :packages
  has_many :deliverables 
  
  has_many :users, :through => :job_attachments 
  has_many :job_attachments
  
  has_many :clients 
  has_many :contact_reports 
  
  
  
  
  has_many :articles
  has_many :sales_orders 
  has_many :projects
  has_many :job_requests
  has_many :suppliers
  
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
  Create Package's Deliverable
=end

  def all_deliverables
    deliverables  = self.deliverables.order("name ASC")
    result = []
    deliverables.each do |deliverable|
      if deliverable.has_sub_item == true 
        result << [ "#{deliverable.name} -- SubItem: #{deliverable.sub_item_name} "+
                "-- Default SubItem Quantity: #{deliverable.sub_item_quantity} "+
                "-- Additional Extra SubItem Price: #{deliverable.independent_sub_item_price}" , 
                        deliverable.id ]
      else
        result << [ "#{deliverable.name}" , 
                        deliverable.id ]
      end
          
    end
    return result
  end
  
=begin
  MASTER DATA: create supplier 
=end

  def create_supplier( employee, supplier_params) 
    supplier = Supplier.new(supplier_params)
    if not employee.has_role?(:admin)
      supplier.errors.add(  :authentication , "Wrong Role: No admin role")
      return supplier
    end
    
    
    
    supplier.office_id = self.id 
    supplier.creator_id = employee.id 
    supplier.save
    
    
    return supplier
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
  
=begin
  BEGINNING OF BACKOFFICE WORK , PROJECT MANAGEMENT HEAD
=end
  def active_projects
    self.projects.where(:is_canceled => false, :is_finished => false )
  end
  
  def finished_projects
    self.projects.where(:is_canceled => false, :is_finished => true).order("finish_date DESC")
  end
  
  def Office.all_crew_role_id_list
    Role.where(:name => [
        USER_ROLE[:pro_photographer],
        USER_ROLE[:amateur_photographer],
        USER_ROLE[:pro_videographer],
        USER_ROLE[:amateur_videographer]
      ]
    ).map{|x| x.id }
  end
  
 
  
  
  def all_crews
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Office.all_crew_role_id_list }  } ).
            order("created_at DESC")
  end
  
  def marketers
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Role.where(:name => USER_ROLE[:marketing]) }  } ).
            order("created_at DESC")
  end
  
  def project_managers
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Role.where(:name => USER_ROLE[:project_manager]) }  } ).
            order("created_at DESC")
  end
  
  def graphic_designers
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Role.where(:name => USER_ROLE[:graphic_designer]) }  } ).
            order("created_at DESC")
  end
  
  def account_executives
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Role.where(:name => USER_ROLE[:account_executive]) }  } ).
            order("created_at DESC")
  end
  
 
  
  def Office.corresponding_role_id_list(project_role)
    if project_role.name == PROJECT_ROLE[:account_executive]
      return Role.where(:name => [
          USER_ROLE[:account_executive] 
        ]
      ).map{|x| x.id }
    end
    
    if project_role.name == PROJECT_ROLE[:graphic_designer]
      return Role.where(:name => [
          USER_ROLE[:graphic_designer] 
        ]
      ).map{|x| x.id }
    end
    
    if project_role.name == PROJECT_ROLE[:project_manager]
      return Role.where(:name => [
          USER_ROLE[:project_manager] 
        ]
      ).map{|x| x.id }
    end
    
    if project_role.name == PROJECT_ROLE[:post_production]
      return Role.where(:name => [
          USER_ROLE[:post_production] 
        ]
      ).map{|x| x.id }
    end
    
    if project_role.name == PROJECT_ROLE[:crew]
      return Office.all_crew_role_id_list
    end
  end
  
  def elligible_employees_for_project_role(project_role)
    self.users.joins(:job_attachments => :assignments ).
            where(:job_attachments => { :assignments => { :role_id => Office.corresponding_role_id_list(project_role) }  } ).
            order("created_at DESC")
  end
  
=begin
  Sales Order Finalization 
=end
  def pending_confirmation_sales_orders
    self.sales_orders.joins(:client).where(:is_confirmed => false, :is_canceled => false )
  end
  
  def confirmed_unfinalized_sales_orders
    self.sales_orders.joins(:client).where(:is_confirmed => false, :is_canceled => false , 
    :is_confirmed => true ) .order("created_at DESC") 
  end
  
=begin
  START PROJECT
=end
  def pending_start_projects
    self.projects.where(:is_canceled => false, :is_started => false ).order("shoot_date ASC")
  end
  
=begin
  POST PRODUCTION
=end

  def all_suppliers
    suppliers  = self.suppliers.order("name ASC")
    result = []
    suppliers.each do |supplier|
      
        result << [ "#{supplier.name}" , 
                        supplier.id ]
          
    end
    return result
  end
  
=begin
  util for job requests
=end
  def crew_booking_job_request_package 
     
    
    job_requests_package = {}
    self.crews.each do |crew|
      job_requests_package[crew.id] = JobRequest.joins(:project).where(
            :user_id => crew.id, :is_canceled => false ,
            :project => {:is_finished => false })
    end
    
    return job_requests_package
  end
  
end
