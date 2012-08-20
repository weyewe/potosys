class DraftsController < ApplicationController
  def new
    @new_draft  = Draft.new
    @project = Project.find_by_id params[:project_id]
    
    @drafts = @project.drafts.order("created_at DESC")
    
    add_breadcrumb "Select Project", 'select_project_to_manage_production_url'
    set_breadcrumb_for @project, 'new_project_draft_url' + "(#{@project.id})", 
          "Manage / Create Draft"
  end
  
  def create
    @project = Project.find_by_id params[:project_id]
    

    @new_draft =  @project.create_draft( current_user, params[:draft])

    if  @new_draft.persisted?
      flash[:notice] = "The <b>draft-#{@new_draft.number}</b> has been created." 
      redirect_to  project_draft_url( @project , @new_draft  ) 
      return 
    else
      flash[:error] = "Hey, do something better"
      @drafts = @project.drafts.order("created_at DESC") 
      
      
      add_breadcrumb "Select Project", 'select_project_to_manage_production_url'
      set_breadcrumb_for @project, 'new_project_draft_url' + "(#{@project.id})", 
            "Manage / Create Draft"
      render :file => "drafts/new"
    end
  end
  
  def show
    @draft= Draft.find_by_id params[:id]
    @project = @draft.project 
    @tasks = @draft.tasks 
    @new_task = Task.new 
    
    add_breadcrumb "Select Project", 'select_project_to_manage_production_url'
    set_breadcrumb_for @project, 'new_project_draft_url' + "(#{@project.id})", 
          "Manage / Create Draft"
    set_breadcrumb_for @draft, 'new_draft_task_url' + "(#{@draft.id})", 
          "Add Detail Task to Draft"
  end
  
  
end
