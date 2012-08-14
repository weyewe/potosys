class ProjectsController < ApplicationController
  
=begin
  Sales Order creation
=end
  def book_crew_for_single_package_sales_order
    @client = Client.find_by_id params[:client_id]
    @package = Package.find_by_id params[:package_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id
      redirect_to deduce_after_sign_in_url
    end

    @new_project = Project.new 


    add_breadcrumb "Search Client", 'search_client_for_single_package_sales_order_url'
    set_breadcrumb_for @client, 'select_package_for_single_package_sales_order_url' + "(#{@client.id})", 
          "Select Package"
    set_breadcrumb_for @client, 'book_crew_for_single_package_sales_order_url' + "(#{@package.id}, #{@client.id})", 
          "Book Crew"


  end

  def execute_crew_booking_for_single_package_sales_order
    @client = Client.find_by_id params[:client_id]
    @package = Package.find_by_id params[:package_id]
    if @package.office_id != current_office.id or @client.office_id != current_office.id
      redirect_to deduce_after_sign_in_url
    end

    @new_project = Project.create_single_package_project( @client, @package, params[:project])

    if  @new_project.persisted?
      flash[:notice] = "The component '#{@new_project.title}' has been created." 
      redirect_to single_package_sales_order_summary_url(@new_project.sales_order ) 
      return 
    else
      flash[:error] = "Hey, do something better"

      render :file => "projects/book_crew_for_single_package_sales_order"
    end


  end
  
    
end
