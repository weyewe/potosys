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
      redirect_to  new_project_draft_url( @project  ) 
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
    @project = @draft.project 
    @job_requests = @draft.project.production_team_job_requests #wrong.. it will only display the job 
    #requests attached to this project/draft
    # what we want: job requests for all the member
     @production_team = @project.production_team
    @job_requests_package = @project.production_team_job_request_package
    @today_date = DateTime.now.to_date 
    
    
    add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_production_mode_url'
    set_breadcrumb_for @draft, 'assign_deadline_for_draft_url' + "(#{@draft.id})", 
          "Schedule Deadline"
  end
  
  def update_draft_deadline
    @draft = Draft.find_by_id params[:draft_id]
    @project= @draft.project
    @draft.set_granted_deadline_date(current_user ,Project.extract_event_date(params[:draft][:start_draft_date]) ,
             Project.extract_event_date(params[:draft][:granted_deadline_date]) )
    
    if @draft.errors.messages.length == 0 
      flash[:notice] = "The deadline for <b>draft-#{@draft.number}</b> has been created." 
      redirect_to  assign_deadline_for_draft_url(   @draft  ) 
      return
    else
      flash[:error] = "Hey, do something better" 
      @job_requests_package = @project.production_team_job_request_package 
      @production_team = @project.production_team
      @today_date = DateTime.now.to_date 
      
      add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_production_mode'
      set_breadcrumb_for @draft, 'assign_deadline_for_draft_url' + "(#{@draft.id})", 
            "Schedule Deadline"
      render :file => "drafts/assign_deadline_for_draft"
      
    end
  end
  
=begin
  Account Executive Finish the draft
=end
  def finish_draft
    @draft = Draft.find_by_id params[:draft_id]
    @draft.finish_draft( current_user ,  Project.extract_event_date(params[:draft][:finish_date])) 
    
    
    if  @draft.is_finished == true 
      flash[:notice] = "The draft '#{@draft.number}' has been finalized."  
    else
      flash[:error] = "Hey, do something better" 
    end
    
    
    redirect_to new_draft_task_url( @draft )
  end
  
  def cancel_draft_finish 
    @draft = Draft.find_by_id params[:draft_id]
    @draft.cancel_finish_draft( current_user )
    
    redirect_to new_draft_task_url( @draft )
  end
  
  
end
