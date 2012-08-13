# client's perspective 
# all clients have important event, whether it is bday, prewedding, etc

class ImportantEvent < ActiveRecord::Base
  attr_accessible :title, :description, :event_date , :is_repeating_annually
  belongs_to :client 
  
  validates_presence_of :title, :event_date 
  
  def creator
    User.find_by_id self.creator_id 
  end
  
  def self.create_by_employee( employee, client , important_event_params)
    important_event = ImportantEvent.new(important_event_params)
    
    
    
    if not( employee.has_role?(:marketing) or employee.has_role?(:marketing_head))
      important_event.errors.add(  :authentication , "Wrong Role: No marketing role")
      return nil
    end
    
    #  cleaning up the boolean 
    if not ( important_event_params[:is_repeating_annually].class == TrueClass or 
        important_event_params[:is_repeating_annually].class == FalseClass  or 
        important_event_params[:is_repeating_annually].nil?)
      if important_event_params[:is_repeating_annually].to_i == TRUE_CHECK
        important_event_params[:is_repeating_annually] = true
      else
        important_event_params[:is_repeating_annually] = false
      end
    end
    
    
    important_event.event_date = ImportantEvent.extract_event_date( important_event_params[:event_date] )
    important_event.save
    
    
    important_event.creator_id = employee.id 
    important_event.client_id = client.id 
    important_event.save
    
    return important_event 
  end
  
  def self.extract_event_date(params_deadline_datetime)
    if params_deadline_datetime.nil? or params_deadline_datetime.length == 0 
      return nil
    end
    
    time_array = params_deadline_datetime.split("/")
    
    DateTime.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i,
                  0, 0, 0,
                  Rational(DEFAULT_TIME_OFFSET, 24) ) # Rational( utc_offset, 24)
  end
  
  def local_event_date
    self.event_date + DEFAULT_TIME_OFFSET.hour
  end
end
