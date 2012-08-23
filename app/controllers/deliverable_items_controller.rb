class DeliverableItemsController < ApplicationController
  def show_deliverable_items_progress
  end
  
=begin
  POST PRODUCTION TEAM 
=end

  def select_deliverable_to_update_progress
    @project=  Project.find_by_id params[:project_id]
    @deliverable_items = @project.deliverable_items.joins(:deliverable)
    
    add_breadcrumb "Select Project", 'select_project_to_update_production_progress_url'
    set_breadcrumb_for @project, 'select_deliverable_to_update_progress_url' + "(#{@project.id})", 
          "Select Deliverable"
  end
  
=begin
  Start deliverable creation
=end
  def start_deliverable_item_creation
    @deliverable_item = DeliverableItem.find_by_id params[:deliverable_item_id]
    @project = @deliverable_item.project 
    @new_purchase_order = @deliverable_item.purchase_order
    
    if @new_purchase_order.nil?
      @new_purchase_order=  PurchaseOrder.new 
    end


    add_breadcrumb "Select Project", 'select_project_to_update_production_progress_url'
    set_breadcrumb_for @project, 'select_deliverable_to_update_progress_url' + "(#{@project.id})", 
          "Select Deliverable"
    set_breadcrumb_for @deliverable_item, 'start_deliverable_item_creation_url' + "(#{@deliverable_item.id})", 
          "Select Deliverable"
  end

  def execute_start_deliverable_item_creation
    
    @deliverable_item = DeliverableItem.find_by_id params[:deliverable_item_id]
    @project = @deliverable_item.project 
    @new_purchase_order = @deliverable_item.create_or_update_purchase_order(current_user,  params[:purchase_order] )


    if @new_purchase_order.persisted?
      flash[:notice]= "Create Purchase order is successful"
      redirect_to select_deliverable_to_update_progress_url(@project)
    else
      flash[:error] = "damn, error "
      add_breadcrumb "Select Project", 'select_project_to_update_production_progress_url'
      set_breadcrumb_for @project, 'select_deliverable_to_update_progress_url' + "(#{@project.id})", 
            "Select Deliverable"
      set_breadcrumb_for @deliverable_item, 'start_deliverable_item_creation_url' + "(#{@deliverable_item.id})", 
            "Select Deliverable"
            
      render :file => 'deliverable_items/start_deliverable_item_creation'
    end 
  end


=begin
  Start deliverable finalization
=end
  def finish_deliverable_item_creation
    @deliverable_item = DeliverableItem.find_by_id params[:deliverable_item_id]
    @project = @deliverable_item.project 
    @purchase_order = @deliverable_item.purchase_order 
     

    add_breadcrumb "Select Project", 'select_project_to_update_production_progress_url'
    set_breadcrumb_for @project, 'select_deliverable_to_update_progress_url' + "(#{@project.id})", 
          "Select Deliverable"
    set_breadcrumb_for @deliverable_item, 'finish_deliverable_item_creation_url' + "(#{@deliverable_item.id})", 
          "Finish Deliverable"
  end

  def execute_finish_deliverable_item_creation
    @deliverable_item = DeliverableItem.find_by_id params[:deliverable_item_id]
    @project = @deliverable_item.project 
    
    @purchase_order= @deliverable_item.finish_creation( current_user,  params[:purchase_order])

    if @purchase_order.errors.messages.length == 0 
      redirect_to select_deliverable_to_update_progress_url(@project)
    else
      add_breadcrumb "Select Project", 'select_project_to_update_production_progress_url'
      set_breadcrumb_for @project, 'select_deliverable_to_update_progress_url' + "(#{@project.id})", 
            "Select Deliverable"
      set_breadcrumb_for @deliverable_item, 'finish_deliverable_item_creation_url' + "(#{@deliverable_item.id})", 
            "Finish Deliverable"
            
      render :file => 'deliverable_items/finish_deliverable_item_creation'
    end

    
  end

=begin
  Start deliverable delivery
=end
  def deliver_deliverable_item_creation
  end

  def execute_deliver_deliverable_item_creation
  end
end
