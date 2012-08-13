class ContactReportsController < ApplicationController
  def index
    @client = Client.find_by_id params[:client_id]
    @contact_reports = @client.contact_reports.order("created_at DESC").limit(10)
    @total_contact_report = @client.contact_reports.count 
    add_breadcrumb "New Client", 'new_client_url'
    set_breadcrumb_for @client, 'client_contact_reports_url' + "(#{@client.id})", 
                  "Contact Report History"
  end
  
  
end
