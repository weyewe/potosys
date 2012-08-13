class ClientsController < ApplicationController
  def new
    @new_client = Client.new 
    @employee_specific_clients = current_office.clients_created_by_employee( current_user ).limit(10)
    @total_client_count = current_office.clients.count 
    add_breadcrumb "New Client", 'new_client_url'
    # set_breadcrumb_for @package, 'new_package_package_assignment_url' + "(#{@package.id})", 
    #               "Create Package Assignment"
                
                
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
end
