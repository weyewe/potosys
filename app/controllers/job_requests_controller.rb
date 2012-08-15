class JobRequestsController < ApplicationController
  def crew_schedule
    @user = User.find_by_id params[:user_id]
    @current_bookings = @user.booked_job_requests(current_office)
    
    add_breadcrumb "Select Crew", select_crew_to_view_calendar_url
    set_breadcrumb_for @user, 'crew_schedule_url' + "(#{@user.id})", 
          "Schedule"
  end
end
