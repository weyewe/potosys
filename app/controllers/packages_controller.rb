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
end
