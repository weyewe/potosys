class ProjectsController < ApplicationController
  
=begin
  Sales Order creation
=end

  def select_crew_to_be_booked
    @client = Client.find_by_id params[:client_id]
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
    @package = Package.find_by_id params[:package_id]
    @user = User.find_by_id params[:user_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id or 
      @user.active_job_attachment.office_id != current_office.id 
      redirect_to deduce_after_sign_in_url
    end

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
    @package = Package.find_by_id params[:package_id]
    @user = User.find_by_id params[:user_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id
      redirect_to deduce_after_sign_in_url
    end

    @new_project = Project.create_single_package_project( current_user, @client, @package, params[:project])

    if  @new_project.persisted?
      flash[:notice] = "The component '#{@new_project.title}' has been created." 
      redirect_to single_package_sales_order_finalization_url(@new_project.sales_order ) 
      return 
    else
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
  
    
end
