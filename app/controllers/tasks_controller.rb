class TasksController < ApplicationController
  
  def new
    @draft= Draft.find_by_id params[:draft_id]
    @project = @draft.project 
    @tasks = @draft.tasks.order("created_at DESC") 
    @new_task = Task.new 
    
    add_breadcrumb "Select Project", 'select_project_to_manage_production_url'
    set_breadcrumb_for @project, 'new_project_draft_url' + "(#{@project.id})", 
          "Manage / Create Draft"
    set_breadcrumb_for @draft, 'new_draft_task_url' + "(#{@draft.id})", 
          "Add Detail Task to Draft"
  end
  
  
  
  
  def create
    @draft= Draft.find_by_id params[:draft_id]
    
    
    
    @new_task = @draft.create_task(current_user, params[:task])

    if  @new_task.persisted?
      flash[:notice] = "The <b>task </b> has been created." 
      redirect_to  new_draft_task_url( @draft  ) 
      return 
    else
      @project = @draft.project 
      @tasks = @draft.tasks.order("created_at DESC") 
      
      add_breadcrumb "Select Project", 'select_project_to_manage_production_url'
      set_breadcrumb_for @project, 'new_project_draft_url' + "(#{@project.id})", 
            "Manage / Create Draft"
      set_breadcrumb_for @draft, 'new_draft_task_url' + "(#{@draft.id})", 
            "Add Detail Task to Draft"
            
      render :file => "tasks/new"
    end
  end
end
