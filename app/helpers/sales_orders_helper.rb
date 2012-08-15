module SalesOrdersHelper
  def add_default_hidden_book_crew_single_package_sales_order_finalization(params)
    if params[:action] != 'create_new_deliverable_item_from_single_package_sales_order_finalization'
      return  'default-hidden'
    end
  end
end
