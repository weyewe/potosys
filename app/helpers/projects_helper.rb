module ProjectsHelper
=begin
  UTILITY CLASS FOR HIDING FORM 
=end
  def add_default_hidden_book_crew_single_package_sales_order(params)
    if params[:action] != 'execute_crew_booking_for_single_package_sales_order'
      return  'default-hidden'
    end
  end
end
