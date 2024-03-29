class SuppliersController < ApplicationController
  def new
    @new_supplier = Supplier.new 
    @office = current_office 
    @suppliers = @office.suppliers.order("created_at DESC").limit( 10 )
  end
  
  def create
    @office = current_office
    
    @new_supplier =  @office.create_supplier( current_user, params[:supplier])
    
    if  @new_supplier.persisted?
      flash[:notice] = "The supplier '#{@new_supplier.name}' has been created." 
      redirect_to new_supplier_url  
      return 
    else
      @suppliers = @office.suppliers.order("created_at DESC").limit( 10 )
      flash[:error] = "Hey, do something better"
      
      render :file => "suppliers/new"
    end
  end
end
