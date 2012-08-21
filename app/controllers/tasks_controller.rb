class TasksController < ApplicationController
  
  def new
    @draft= Draft.find_by_id params[:draft_id]
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
