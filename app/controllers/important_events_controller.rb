class ImportantEventsController < ApplicationController
  def new 
    @client = Client.find_by_id params[:client_id]
    @important_events = @client.important_events.order("created_at DESC").limit(10)
    @total_important_event_count = @client.important_events.count 
    
    @new_important_event = ImportantEvent.new 
    add_breadcrumb "Search Client", 'search_client_for_marketing_interaction_url'
    set_breadcrumb_for @client, 'new_client_important_event_url' + "(#{@client.id})", 
                  "Client Important Event"
  end
  
  
  def index 
    @client = Client.find params[:client_id]
    @important_events = @client.important_events
    
    add_breadcrumb "Search Client", 'new_client_url'
    set_breadcrumb_for @client, 'client_important_events_url' + "(#{@client.id})", 
                  "Important Events for #{@client.name}"
  end
  
  def create 
    @client = Client.find_by_id params[:client_id]
    @important_events = @client.important_events.order("created_at DESC").limit(10)
    @total_important_event_count = @client.important_events.count 
    
    @new_important_event = ImportantEvent.create_by_employee( current_user, @client , params[:important_event] )
    
    if  @new_important_event.persisted?
      flash[:notice] = "The Contact Report: '#{@new_important_event.title}' has been created." 
      redirect_to new_client_important_event_url(@client) 
      return 
    else
      flash[:error] = "Hey, do something better"
      
      add_breadcrumb "Search Client", 'search_client_for_marketing_interaction_url'
      set_breadcrumb_for @client, 'new_client_important_event_url' + "(#{@client.id})", 
                    "Client Important Event"
      render :file => "important_events/new"
    end
  end
  
  def all_important_events
    if ( params[:important_event_period].nil? or params[:important_event_period].length == 0  ) and 
          not   ImportantEvent.is_numeric?(params[:important_event_period]) 
      @important_event_period = DEFAULT_IMPORTANT_EVENT_PERIOD 
      @important_events = ImportantEvent.important_events_within_n_days_from_now( DEFAULT_IMPORTANT_EVENT_PERIOD , current_office )
    else
      @important_event_period = params[:important_event_period].to_i  
      @important_events = ImportantEvent.important_events_within_n_days_from_now( @important_event_period , current_office )
    end
  end
  
  
end
