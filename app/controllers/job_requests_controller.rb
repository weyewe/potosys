class JobRequestsController < ApplicationController
  def crew_schedule
    @user = User.find_by_id params[:user_id]
    @current_bookings = @user.booked_job_requests(current_office)
    
    add_breadcrumb "Select Crew", select_crew_to_view_calendar_url
    set_breadcrumb_for @user, 'crew_schedule_url' + "(#{@user.id})", 
          "Schedule"
  end
  
  
=begin
  DEADLINE BOOKING 
=end
  def execute_job_request_for_draft_deadline
    @draft = Draft.find_by_id params[:draft_id]
  end
  
=begin
  POST PRODUCTION JOB REQUEST 
=end

  def create_post_production_job_request
    @project= Project.find_by_id params[:project_id]
    
    @job_request = @project.create_or_update_post_production_job_request(current_user,  params[:job_request] )
    
    if @job_request.errors.messages.length ==  0 
      redirect_to assign_deadline_for_post_production_url(@project)
    else
      @job_requests = JobRequest.where(:user_id => @project.post_production_team.map{ |x| x.user_id } , :is_canceled => false )    
      
      add_breadcrumb "Select Project", 'select_project_to_be_scheduled_in_post_production_mode_url'
      set_breadcrumb_for @project, 'assign_deadline_for_post_production_url' + "(#{@project.id})", 
            "Schedule Deadline"

      render :file => 'projects/project_management/assign_deadline_for_post_production'
    end
    
  end
  
  def show_production_calendar
    @job_requests = current_user.pending_finalization_job_requests
    add_breadcrumb "Show Calendar", 'show_production_calendar_url'
  end
end
