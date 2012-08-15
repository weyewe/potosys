class DeliverableSubcriptionsController < ApplicationController
  def new
    @package = Package.find_by_id params[:package_id]
    @deliverable_subcriptions = @package.deliverable_subcriptions
    @new_deliverable_subcription = DeliverableSubcription.new
    
    add_breadcrumb "New Package", 'new_package_url'
    set_breadcrumb_for @package, 'new_package_deliverable_subcription_url' + "(#{@package.id})", 
          "Assign + Edit Deliverable"
  end
  
  
  def create
    @package = Package.find_by_id params[:package_id]
    @deliverable_subcriptions = @package.deliverable_subcriptions 
    @new_deliverable_subcription = @package.assign_deliverable(current_user, params[:deliverable_subcription])
    
    if  @new_deliverable_subcription.persisted?
      flash[:notice] = "The component '#{@new_deliverable_subcription.deliverable.name}' has been created." 
      redirect_to new_package_deliverable_subcription_url(@package)
      return 
    else
      flash[:error] = "Hey, do something better"
      add_breadcrumb "New Package", 'new_package_url'
      set_breadcrumb_for @package, 'new_package_deliverable_subcription_url' + "(#{@package.id})", 
            "Assign + Edit Deliverable"
      
      render :file => "deliverable_subcriptions/new"
    end
  end
  
  
end
