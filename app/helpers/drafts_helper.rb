module DraftsHelper
  def add_default_hidden_create_deadline_for_draft(params)
    if params[:action] != 'assign_deadline_for_draft'
      return  'default-hidden'
    end
  end
  
  def get_special_date_calendar_for_draft(job_request, today_date )
    if job_request.finish_date.nil? and today_date > job_request.ending_date 
      today_date
    else 
      job_request.ending_date  
    end 
  end
end
