class ContactReport < ActiveRecord::Base
  attr_accessible :summary, :description , :contact_datetime#, :contact_datetime
  belongs_to :client 
  belongs_to :user 
  belongs_to :office 
  
  validates_presence_of :summary , :contact_datetime
  
  def self.create_by_employee( employee, client ,contact_hour,  contact_report_params )
    # contact_report_params.delete(:contact_datetime)
    #  contact_report_params.delete(:contact_hour)
    contact_report = ContactReport.new(contact_report_params)
    
    
    
    if not( employee.has_role?(:marketing) or employee.has_role?(:marketing_head))
      contact_report.errors.add(  :authentication , "Wrong Role: No marketing role")
      return nil
    end
    contact_report.contact_datetime = ContactReport.extract_date_time( contact_report_params[:contact_datetime], contact_hour)
    contact_report.save
    
    contact_report.office_id =  employee.active_job_attachment.office_id 
    contact_report.user_id = employee.id 
    contact_report.client_id = client.id 
    contact_report.save
    
    return contact_report 
  end
  
  
  
  def self.extract_date_time( params_deadline_datetime, params_hour )
    if params_deadline_datetime.nil? or params_deadline_datetime.length ==0 
      return nil
    end
    
    time_array = params_deadline_datetime.split("/")
  
    hour = 0 
    if params_hour.nil? || params_hour.length ==0  
      hour = 0
    else
      hour = (params_hour.to_i) %24
    end
    
    minute = 0 
    # if params_minute.nil? || params_minute.length ==0  
    #   minute = 0
    # else
    #   minute = params_minute.to_i
    # end        
              
              
              
    DateTime.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i,
                  hour, minute, 0,
                  Rational(DEFAULT_TIME_OFFSET, 24) ) # Rational( utc_offset, 24)
  end
  
  def local_contact_datetime 
    self.contact_datetime + DEFAULT_TIME_OFFSET.hour
  end
  
=begin
  SALES ORDER, in SALES&MARKETING management 
=end
  def self.list_contact_reports_created_by( user, starting_date, ending_date  )
    starting_datetime = Time.new( starting_date.year, starting_date.month, starting_date.day, 23,59,59)
    ending_datetime = Time.new( ending_date.year, ending_date.month, ending_date.day, 23,59,59)
    ContactReport.joins(:user).where{
      (user_id.eq user.id) & 
      (contact_datetime.gte starting_datetime) & 
      (contact_datetime.lte ending_datetime) 
    }.order("created_at DESC")
  end
  
  def self.customer_engagements_between(office, starting_date, ending_date  )
    starting_datetime = Time.new( starting_date.year, starting_date.month, starting_date.day, 23,59,59)
    ending_datetime = Time.new( ending_date.year, ending_date.month, ending_date.day, 23,59,59)
    
    office.contact_reports.joins(:user).where{
      (contact_datetime.gte starting_datetime) & 
      (contact_datetime.lte ending_datetime) 
    }.order("created_at DESC")
  end
end
