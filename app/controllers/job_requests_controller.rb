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
end
