class SalesOrdersController < ApplicationController
  def index
    @client = Client.find_by_id params[:client_id]
    @sales_orders = @client.sales_orders.order("created_at DESC").limit(10)
    @total_sales_order_count = @client.sales_orders.count 
    add_breadcrumb "New Client", 'new_client_url'
    set_breadcrumb_for @client, 'client_sales_orders_url' + "(#{@client.id})", 
                  "Purchase History"
  end
  
  def single_package_sales_order_finalization
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    @project = @sales_order.projects.first 
    @package = @project.package
    @deliverable_items = @project.deliverable_items.order("created_at DESC")
    
    @new_deliverable_item = DeliverableItem.new 
    
    
  end
  
  def create_new_deliverable_item_from_single_package_sales_order_finalization
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    @project = @sales_order.projects.first 
    @package = @project.package
    @deliverable_items = @project.deliverable_items.order("created_at DESC")
    
    @new_deliverable_item = @project.add_deliverable_item(current_user, params[:deliverable_item])
    
    if  @new_deliverable_item.persisted?
      flash[:notice] = "The component '#{@new_deliverable_item.deliverable.name}' has been created." 
      redirect_to single_package_sales_order_finalization_url( @sales_order ) 
      return 
    else
      flash[:error] = "Hey, do something better"
      
      render :file => "sales_orders/single_package_sales_order_finalization"
    end
  end
  
=begin
  Finalize Sales Order FROM THE CREATION FLOW
=end

  def finalize_sales_order_single_package
    @sales_order = SalesOrder.find_by_id params[:sales_order_id]
    @sales_order.confirm_sales_order( current_user ) 
    
    
    redirect_to 
    
  end
  
end
