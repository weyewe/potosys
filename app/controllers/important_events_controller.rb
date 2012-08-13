class ImportantEventsController < ApplicationController
  def index
    @client = Client.find_by_id params[:client_id]
    @important_events = @client.important_events.order("created_at DESC").limit(10)
    @total_important_event_count = @client.important_events.count 
    add_breadcrumb "New Client", 'new_client_url'
    set_breadcrumb_for @client, 'client_important_events_url' + "(#{@client.id})", 
                  "Client Important Event"
  end
end
