class ClientsController < ApplicationController
  def new
    @new_client = Client.new 
    @employee_specific_clients = current_office.clients_created_by_employee( current_user ).limit(10)
    @total_client_count = current_office.clients.count 
    add_breadcrumb "New Client", 'new_client_url'
  end
  
  def search_client_for_marketing_interaction
    @office = current_office
    @clients = [] 
    if not  params[:client_name].nil?  and not params[:client_name].length == 0 
      name_query = '%' + params[:client_name] + '%'
      office = @office
      @clients = @office.clients.where{ (name =~ name_query)  }
    end
    
    add_breadcrumb "Search Client", 'search_client_for_marketing_interaction_url' 
  end
  
  def create
    @office = current_office
    
    @new_client =  @office.create_client( current_user, params[:client])
    
    if  @new_client.persisted?
      flash[:notice] = "The component '#{@new_client.name}' has been created." 
      redirect_to new_client_url 
      return 
    else
      flash[:error] = "Hey, do something better"
      @employee_specific_clients = current_office.clients_created_by_employee( current_user ).limit(10)
                                        
      @total_client_count = current_office.clients.count
      add_breadcrumb "New Client", 'new_client_url'
      render :file => "clients/new"
    end
  end
  
=begin
  SALES ORDER CREATION
=end

  def search_client_for_single_package_sales_order
    @office = current_office
    @clients = [] 
    if not  params[:client_name].nil?  and not params[:client_name].length == 0 
      name_query = '%' + params[:client_name] + '%'
      office = @office
      @clients = @office.clients.where{ (name =~ name_query)  }
    end
    
    add_breadcrumb "Search Client", 'search_client_for_single_package_sales_order_url'
    render :file => "clients/sales_orders/search_client_for_single_package_sales_order"
  end
end
