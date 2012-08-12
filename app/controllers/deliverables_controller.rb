class DeliverablesController < ApplicationController
  def new
    @new_deliverable = Deliverable.new 
    @office = current_office 
  end
  
  def create
    @office = current_office
    
    @new_deliverable =  @office.create_deliverable( current_user, params[:deliverable])
    
    if  @new_deliverable.persisted?
      flash[:notice] = "The component '#{@new_deliverable.name}' has been created." 
      redirect_to new_deliverable_url 
      return 
    else
      flash[:error] = "Hey, do something better"
      
      render :file => "deliverables/new"
    end
  end
end
