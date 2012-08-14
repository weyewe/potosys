class DeliverableSubcriptionsController < ApplicationController
  def new
    @package = Package.find_by_id params[:package_id]
    @deliverable_subcriptions = @package.deliverable_subcriptions 
    @new_deliverable_subcription = DeliverableSubcription.new
    
    add_breadcrumb "New Package", 'new_package_url'
    set_breadcrumb_for @package, 'new_package_deliverable_subcription_url' + "(#{@package.id})", 
          "Assign + Edit Deliverable"
          
          
  end
end
