class PackageAssignmentsController < ApplicationController
  def new
    @package = Package.find_by_id params[:package_id]
    if @package.office_id != current_office.id 
      redirect_to root_url
    end
    
    @office = current_office
    @crews = current_office.crews 
    
   
    add_breadcrumb "Add Package", 'new_package_url'
    set_breadcrumb_for @package, 'new_package_package_assignment_url' + "(#{@package.id})", 
                "Create Package Assignment"
  end
  
  
  def create_package_assignment
    @decision = params[:membership_decision].to_i
    @package = Package.find_by_id params[:membership_provider]
    @user = User.find_by_id params[:membership_consumer]
    
  
    if @decision == TRUE_CHECK
      @package.assign_crew_to_package( @user , current_user )
    elsif @decision == FALSE_CHECK
      @package.remove_crew_from_package( @user, current_user )
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
  
  def edit_crew_specific_package_price
    @package = Package.find_by_id params[:package_id]
    @user = User.find_by_id params[:crew_id]
    
    @package.edit_crew_specific_pricing(@user, current_user, params[:price] )
    
  end
end
