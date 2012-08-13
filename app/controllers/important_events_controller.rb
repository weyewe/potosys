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
  
  
end
