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
  
=begin
  Project Management planning
=end

  def assign_deadline_for_draft
    @draft = Draft.find_by_id params[:draft_id]
    @job_requests = @draft.project.production_team_job_requests
    
    add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_production_mode'
    set_breadcrumb_for @draft, 'assign_deadline_for_draft_url' + "(#{@draft.id})", 
          "Schedule Deadline"
  end
  
  def update_draft_deadline
    @draft = Draft.find_by_id params[:draft_id]
    
    @draft.set_granted_deadline_date(current_user ,  Project.extract_event_date(params[:draft][:granted_deadline_date]) )
    
    if @draft.errors.messages[:granted_deadline_date] != 0 
      flash[:notice] = "The deadline for <b>draft-#{@draft.number}</b> has been created." 
      redirect_to  assign_deadline_for_draft_url(   @draft  ) 
      return
    else
      flash[:error] = "Hey, do something better"
      @job_requests = @draft.project.production_team_job_requests
      
      
      add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_production_mode'
      set_breadcrumb_for @draft, 'assign_deadline_for_draft_url' + "(#{@draft.id})", 
            "Schedule Deadline"
      render :file => "drafts/assign_deadline_for_draft"
      
    end
      
    
  end
  
  
end
