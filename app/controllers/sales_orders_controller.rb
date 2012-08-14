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
    
  end
  
end