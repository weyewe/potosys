class OfficesController < ApplicationController
  def new_employee_creation
    @new_employee = User.new 
    @employees = current_office.users
  end
  
  def create_employee
    @new_employee = current_office.create_employee_by_email( params[:user][:email])
    
    if not @new_employee.nil? and @new_employee.valid?
      flash[:notice] = "The employee '#{@new_employee.email}' has been created." 
      redirect_to new_employee_creation_url
      return 
    else
      @employees = current_office.users
      @new_employee = User.new 
      flash[:error] = []
      if params[:user][:email].nil? or params[:user][:email].length == 0 
        flash[:error] << "Email has to be present"
      end
      
      if User.find_by_email(params[:user][:email]).nil?
        flash[:error] << "There is duplicate email"
      end
        
      render :file => "offices/new_employee_creation"
    end
  end
  
  def show_role_for_employee
    @employee = User.find_by_id params[:employee_id]
    @roles = Role.find(:all, :order => "created_at DESC")
    
    add_breadcrumb "Select Employee", 'new_employee_creation_url'
    set_breadcrumb_for @employee, 'show_role_for_employee_url' + "(#{@employee.id})", 
                "Employee Role"
                
                
  end
  
  def assign_role_for_employee
    @decision = params[:membership_decision].to_i
    @role = Role.find_by_id params[:membership_provider]
    @employee = User.find_by_id params[:membership_consumer]
    @office = current_office
  
    if @decision == TRUE_CHECK
      puts "**** WE are calling add role "
      @employee.add_role(@role, @office, current_user)
    elsif @decision == FALSE_CHECK
      puts "((((( We are calling remove role)))))"
      @employee.remove_role(@role, @office,current_user)
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
  
  def test_crew_calendar
    @office = current_office
    @crews = current_office.crews 
  end
  
  def select_crew_to_view_calendar
    @office = current_office
    @crews = current_office.crews
    add_breadcrumb "Select Crew", select_crew_to_view_calendar_url
  end
  
  
  def show_all_bookings
    @crews = current_office.crews
    @job_requests_package = current_office.crew_booking_job_request_package
    add_breadcrumb "Current + Future Bookings", show_all_bookings_url
  end
end
