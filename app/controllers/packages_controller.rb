class PackagesController < ApplicationController
  def new
    @new_package = Package.new 
    @office = current_office 
  end
  
  def create
    @office = current_office
    
    @new_package =  @office.create_package( current_user, params[:package])
    
    if  @new_package.persisted?
      flash[:notice] = "The component '#{@new_package.name}' has been created." 
      redirect_to new_package_url 
      return 
    else
      flash[:error] = "Hey, do something better"
      
      render :file => "packages/new"
    end
  end
  
  
=begin
  Sales Order creation: single package
=end
  def select_package_for_single_package_sales_order
    @client = Client.find_by_id params[:client_id]
    
    if @client.has_unconfirmed_sales_order?(current_office)
      redirect_to single_package_sales_order_finalization_url( @client.pending_sales_order_confirmation(current_office))
      return 
    end
    
    @packages = current_office.packages.order("name ASC")
    
    add_breadcrumb "Search Client", 'search_client_for_single_package_sales_order_url'
    set_breadcrumb_for @client, 'select_package_for_single_package_sales_order_url' + "(#{@client.id})", 
          "Select Package"
    
    render :file => "packages/sales_orders/select_package_for_single_package_sales_order"
  end
  
end

