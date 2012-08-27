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
  
=begin
  SALES&MArketing PENDING CONFIRMATIONS 
=end
  
  def pending_confirmation_sales_orders
    @sales_orders = current_office.pending_confirmation_sales_orders
    add_breadcrumb "Pending Confirmation", pending_confirmation_sales_orders_url
  end
=begin
  SALES AND MARKETING MANAGEMENT 
=end

  def select_employee_to_view_marketing_performance
    @marketers = current_office.marketers 
    @starting_date = ''
    @ending_date = ''
    today_date = Time.now.to_date
    
    if params[:starting_date].nil?  or params[:starting_date].length == 0 
      @starting_date = Date.new( today_date.year, today_date.month, 1 )
    else
      @starting_date = Project.extract_event_date(params[:starting_date])
    end
    
    if params[:ending_date].nil?  or params[:ending_date].length == 0 
      @ending_date = today_date
    else
      @ending_date = Project.extract_event_date(params[:ending_date])
    end
    
    add_breadcrumb "Overall Marketing Performance", select_employee_to_view_marketing_performance_url
    render :file => 'offices/marketing_management/select_employee_to_view_marketing_performance'
  end
  
  def marketing_performance_for
  end
  
  def customer_engagements
    # @marketers = current_office.marketers 
    @starting_date = ''
    @ending_date = ''
    today_date = Time.now.to_date
    
    if params[:starting_date].nil?  or params[:starting_date].length == 0 
      @starting_date = Date.new( today_date.year, today_date.month, 1 )
    else
      @starting_date = Project.extract_event_date(params[:starting_date])
    end
    
    if params[:ending_date].nil?  or params[:ending_date].length == 0 
      @ending_date = today_date
    else
      @ending_date = Project.extract_event_date(params[:ending_date])
    end
    
    @contact_reports = ContactReport.customer_engagements_between(current_office, @starting_date, @ending_date )
    
    add_breadcrumb "Customer Engagements", customer_engagements_url
    render :file => 'offices/marketing_management/customer_engagements'
  end
  
  def sales_summary
    @starting_date = ''
    @ending_date = ''
    today_date = Time.now.to_date
    
    if params[:starting_date].nil?  or params[:starting_date].length == 0 
      @starting_date = Date.new( today_date.year, today_date.month, 1 )
    else
      @starting_date = Project.extract_event_date(params[:starting_date])
    end
    
    if params[:ending_date].nil?  or params[:ending_date].length == 0 
      @ending_date = today_date
    else
      @ending_date = Project.extract_event_date(params[:ending_date])
    end
    
    @sales_orders = SalesOrder.sales_orders_between(current_office, @starting_date, @ending_date )
    
    add_breadcrumb "Customer Engagements", customer_engagements_url
    render :file => 'offices/marketing_management/sales_summary'
  end
end
