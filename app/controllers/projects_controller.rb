class ProjectsController < ApplicationController
  
=begin
  Sales Order creation
=end

  def select_crew_to_be_booked
    @client = Client.find_by_id params[:client_id]
    if @client.has_unconfirmed_sales_order?(current_office)
      redirect_to single_package_sales_order_finalization_url( @client.pending_sales_order_confirmation(current_office))
      return 
    end
    
    
    @package = Package.find_by_id params[:package_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id 
      redirect_to deduce_after_sign_in_url
    end
    
    @crews = @package.users 



    add_breadcrumb "Search Client", 'search_client_for_single_package_sales_order_url'
    set_breadcrumb_for @client, 'select_package_for_single_package_sales_order_url' + "(#{@client.id})", 
          "Select Package"
    set_breadcrumb_for @client, 'select_crew_to_be_booked_url' + "(#{@package.id}, #{@client.id})", 
          "Select Crew"
  end
  
  
  def book_crew_for_single_package_sales_order
    @client = Client.find_by_id params[:client_id]
    if @client.has_unconfirmed_sales_order?(current_office)
      redirect_to single_package_sales_order_finalization_url( @client.pending_sales_order_confirmation(current_office))
      return 
    end
    
    
    
    @package = Package.find_by_id params[:package_id]
    @user = User.find_by_id params[:user_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id or 
      @user.active_job_attachment.office_id != current_office.id 
      redirect_to deduce_after_sign_in_url
    end
    
    @current_bookings = @user.booked_job_requests(current_office)

    @new_project = Project.new 


    add_breadcrumb "Search Client", 'search_client_for_single_package_sales_order_url'
    set_breadcrumb_for @client, 'select_package_for_single_package_sales_order_url' + "(#{@client.id})", 
          "Select Package"
    set_breadcrumb_for @client, 'select_crew_to_be_booked_url' + "(#{@package.id}, #{@client.id})", 
          "Select Crew"
    set_breadcrumb_for @client, 'book_crew_for_single_package_sales_order_url' + "(#{@package.id}, #{@client.id}, #{@user.id})", 
          "Book Shoot Date"


  end

  def execute_crew_booking_for_single_package_sales_order
    @client = Client.find_by_id params[:client_id]
    if @client.has_unconfirmed_sales_order?(current_office)
      redirect_to single_package_sales_order_finalization_url( @client.pending_sales_order_confirmation(current_office))
      return 
    end
    
    
    @package = Package.find_by_id params[:package_id]
    @user = User.find_by_id params[:user_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id
      redirect_to deduce_after_sign_in_url
    end

    @new_project = Project.create_single_package_project( current_user, @client, @package, @user, params[:project])

    if  @new_project.persisted?
      flash[:notice] = "The component '#{@new_project.title}' has been created." 
      redirect_to single_package_sales_order_finalization_url(@new_project.sales_order ) 
      return 
    else
      @current_bookings = @user.booked_job_requests(current_office)
      flash[:error] = "Hey, do something better"

      set_breadcrumb_for @client, 'select_package_for_single_package_sales_order_url' + "(#{@client.id})", 
            "Select Package"
      set_breadcrumb_for @client, 'select_crew_to_be_booked_url' + "(#{@package.id}, #{@client.id})", 
            "Select Crew"
      set_breadcrumb_for @client, 'book_crew_for_single_package_sales_order_url' + "(#{@package.id}, #{@client.id}, #{@user.id})", 
            "Book Shoot Date"
            
      render :file => "projects/book_crew_for_single_package_sales_order"
    end
  end
  
  
=begin
  BEGINNING OF BACKOFFICE WORK , PROJECT MANAGEMENT HEAD
=end
  def select_project_for_project_membership_assignment
    @projects = current_office.active_projects
    
    add_breadcrumb "Select Project", 'select_project_for_project_membership_assignment_url'
    render :file => "projects/project_memberships/select_project_for_project_membership_assignment"
  end
  
  def select_role_to_assign_employee
    @project = Project.find_by_id params[:project_id]
    @package = @project.package
    @project_roles = ProjectRole.order("created_at DESC")
    
    add_breadcrumb "Select Project", 'select_project_for_project_membership_assignment_url'
    set_breadcrumb_for @project, 'select_role_to_assign_employee_url' + "(#{@project.id})", 
          "Select Role"
          
    render :file => "projects/project_memberships/select_role_to_assign_employee"
  end
  
=begin
  START PROJECT 
=end
  def select_project_to_be_started
    @projects = current_office.pending_start_projects
    
    add_breadcrumb "Select Project", 'select_project_to_be_started_url'
    render :file => "projects/start_project/select_project_to_be_started" 
  end
  
  def start_project
    @project = Project.find_by_id params[:entity_id]
    @project.start_project( current_user )
  end


=begin
  PRODUCTION MANAGEMENT 
=end

  def select_project_to_manage_production
    @projects = current_user.assigned_projects_for( PROJECT_ROLE[:account_executive] ) 
    
    add_breadcrumb "Select Project", 'select_project_to_manage_production_url'
    render :file => "projects/project_management/select_project_to_manage_production"
  end

=begin
  PROJECT MANAGER's 
=end  
  def select_project_to_be_scheduled_in_production_mode
    @projects = current_user.assigned_projects_for( PROJECT_ROLE[:project_manager] ) 
    add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_production_mode_url'
    
    render :file => "projects/project_management/select_project_to_be_scheduled_in_production_mode"
  end
  
=begin
  Account Executive Finalize Production
=end
  def finalize_production
    @project = Project.find_by_id params[:project_id]
    production_finish_date = Project.extract_event_date(params[:project][:production_finish_date])
    
    @project.finalize_production( current_user, production_finish_date ) 
    
    if  @project.is_production_finished == true 
      flash[:notice] = "The project '#{@project.title}' has been finalized."  
    else
      flash[:error] = "Hey, do something better" 
    end
    
    redirect_to new_project_draft_url( @project ) 
    
  end
  
  def cancel_production_finalization
    @project = Project.find_by_id params[:project_id]
    
    @project.cancel_production_finalization( current_user  ) 
    
     
    
    redirect_to new_project_draft_url( @project )
  end
  
  
=begin
  POST production management 
=end
  def select_project_to_monitor_post_production
    @projects = current_user.assigned_projects_for( PROJECT_ROLE[:account_executive] )
    
    add_breadcrumb "Select Project", 'select_project_to_monitor_post_production_url'
    render :file => "projects/project_management/select_project_to_monitor_post_production"
  end
  
  def select_project_to_be_scheduled_in_post_production_mode
    @projects = current_user.assigned_projects_for( PROJECT_ROLE[:project_manager] ) 
    add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_post_production_mode'
    
    render :file => "projects/project_management/select_project_to_be_scheduled_in_post_production_mode"
  end
  
  def assign_deadline_for_post_production
    @project = Project.find_by_id params[:project_id]
    @job_request = @project.post_production_scheduling_job_requests.first
    @job_requests = JobRequest.where(:user_id => @project.post_production_team.map{ |x| x.user_id } , :is_canceled => false )    
    
    if @job_request.nil?
      @job_request = JobRequest.new 
    end 
    
    add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_post_production_mode_url'
    set_breadcrumb_for @project, 'assign_deadline_for_post_production_url' + "(#{@project.id})", 
          "Schedule Deadline"
          
    render :file => 'projects/project_management/assign_deadline_for_post_production'
  end
  
=begin
  POST PRODUCTIOn, by POST PRODUCTION TEAM 
=end
  def select_project_to_update_production_progress
    @projects = current_user.assigned_projects_for( PROJECT_ROLE[:post_production] ) 
    add_breadcrumb "Select Project", 'select_project_to_update_production_progress_url'
    
    render :file => "projects/project_management/select_project_to_update_production_progress"
  end
  
end
