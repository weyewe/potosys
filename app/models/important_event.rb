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
    
    new_event_date = ImportantEvent.extract_event_date( important_event_params[:event_date] )
    important_event.event_date = new_event_date
    important_event.save
    
    if not new_event_date.nil?
      important_event.yday = new_event_date.yday 
    end
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
    
    Date.new(time_array[2].to_i, time_array[0].to_i, time_array[1].to_i) 
  end
  
  def local_event_date
    self.event_date + DEFAULT_TIME_OFFSET.hour
  end
  
  def self.important_events_within_n_days_from_now( number_of_days , office )
    # date#yday => returns the day of the year 
    # 1-366 
    # => Date.new(2001,2,3).yday           #=> 34
    today_yday = DateTime.now.to_date.yday
    total_yday = today_yday + number_of_days 
    
    excess_yday = total_yday - MAX_YDAY 
    if excess_yday != 0 
      ImportantEvent.joins(:client).where{
        ( client.office_id.eq office.id ) & 
        (
            ( (yday.gte today_yday) & (yday.lte MAX_YDAY) )  |
            ( (yday.gte MIN_YDAY) & (yday.lte excess_yday) )  
        )
      }
    else
      ImportantEvent.joins(:client).where{
        (client.office_id.eq office.id ) & 
        ( (yday.gte today_yday)  & (yday.lte total_yday)  ) 
      }
    end
    
  end
end
