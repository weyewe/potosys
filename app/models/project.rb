class Project < ActiveRecord::Base
  attr_accessible :title, :shoot_date, :starting_date,  :ending_date, :shoot_location, :project_guideline 
  belongs_to :package
  has_many :deliverables, :through => :deliverable_items
  has_many :deliverable_items
  
  has_many :drafts
  
  has_many :project_memberships 
  has_many :users, :through => :project_memberships
  
  
  validates_presence_of :title, :shoot_date, :starting_date, :ending_date , :shoot_location 
  
  def Project.create_single_package_project( employee , client, package, project_params )
    project = Project.new project_params 
    
    if not (employee.has_role?(:marketing) or employee.has_role?(:marketing_head) )
      puts "88888 employee wrong role"
      project.errors.add(  :authentication , "Wrong Role: No admin role")
      return project
    end
    
    office = employee.active_job_attachment.office
    if not ( client.office_id ==  office.id  or package.office_id == office.id) 
      puts "111111 wrong office"
      project.errors.add(  :authentication , "Wrong Role: Different Office")
      return project
    end
    
    shoot_date = Project.extract_event_date(project_params[:shoot_date])
    starting_date = Project.extract_event_date(project_params[:starting_date])
    ending_date = Project.extract_event_date(project_params[:ending_date])
    
    
    if not(  starting_date.nil? or shoot_date.nil? or ending_date.nil? )
      if not ( starting_date <= shoot_date  and  shoot_date <= ending_date  and starting_date<= ending_date)
        if starting_date > shoot_date 
          project.errors.add(  :starting_date , "Starting date has to be earlier than or equal  shoot date")
        end
      
        if shoot_date > ending_date
          project.errors.add(  :ending_date , "Ending date has to be later than or equal  shoot date")
        end
        
        if starting_date > ending_date
          project.errors.add(  :starting_date , "Starting date has to be earlier than or equal  ending date")
        end
        puts "000000 wrong date"
        project.save 
        return project
      end
    else
      puts "333333 no date params"
      project.save
      return project
    end
    project.save
    
    project.package_id = package.id 
    project.save
    
    #  creating the sales order
    sales_order = SalesOrder.new
    sales_order.creator_id = employee.id 
    sales_order.client_id = client.id 
    sales_order.title = project.title
    sales_order.description = project.project_guideline
    sales_order.save 
    project.sales_order_id = sales_order.id 
    project.save 
    
    return project 
    
  end
  
  
  def self.extract_event_date(params_deadline_datetime)
    if params_deadline_datetime.nil? or params_deadline_datetime.length == 0 
      return nil
    end
    
    time_array = params_deadline_datetime.split("/")
    
    Date.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i) 
  end
  
end
