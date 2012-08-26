class ContactReportsController < ApplicationController
  def index
    @client = Client.find params[:client_id]
    @contact_reports = @client.contact_reports.order("created_at DESC")
    
    add_breadcrumb "Search Client", 'new_client_url'
    set_breadcrumb_for @client, 'client_contact_reports_url' + "(#{@client.id})", 
                  "Contact Reports for #{@client.name}"
  end
  
  def new
    @new_contact_report = ContactReport.new 
    @client = Client.find_by_id params[:client_id]
    @contact_reports = @client.contact_reports.order("created_at DESC").limit(10)
    @total_contact_report = @client.contact_reports.count 
    add_breadcrumb "Search Client", 'search_client_for_marketing_interaction_url'
    set_breadcrumb_for @client, 'new_client_contact_report_url' + "(#{@client.id})", 
                  "Contact Report History"
  end
  
  def create
    
    @new_contact_report = ContactReport.new 
    @client = Client.find_by_id params[:client_id]
    @contact_reports = @client.contact_reports.order("created_at DESC").limit(10)
    @total_contact_report = @client.contact_reports.count 
    
    @new_contact_report = ContactReport.create_by_employee( current_user, @client ,params[:contact_hour], params[:contact_report]   )
    
    
    if  @new_contact_report.persisted?
      flash[:notice] = "The Contact Report: '#{@new_contact_report.summary}' has been created." 
      redirect_to new_client_contact_report_url(@client) 
      return 
    else
      flash[:error] = "Hey, do something better"
      
      add_breadcrumb "Search Client", 'search_client_for_marketing_interaction_url'
      set_breadcrumb_for @client, 'new_client_contact_report_url' + "(#{@client.id})", 
                    "Contact Report History"
      render :file => "contact_reports/new"
    end
    
    
    
  end
  
  
end
