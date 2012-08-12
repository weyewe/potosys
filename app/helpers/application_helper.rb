module ApplicationHelper
  ACTIVE = 'active'
  REVISION_SELECTED = "selected"
  NEXT_BUTTON_TEXT = "Next &rarr;"
  PREV_BUTTON_TEXT = " &larr; Prev "
  
  
=begin
  FRONT_PAGE NAVIGATION 
=end
  def front_page_navigation_class(entry_symbol, params)
    if entry_symbol == :home
      if params[:controller] == "home" && params[:action] == "homepage"
        return "active"
      end
    end
    
    if entry_symbol == :blog
      if params[:controller] == "home" && params[:action] == "blog"
        return "active"
      end
    end
    
    if entry_symbol == :login
    end
  end
  
  
=begin
  TRANSLOADIT RELATED 
=end

  def transloadit_with_max_size( template , size_mb )

    if Rails.env.production?
      transloadit_read = YAML::load( File.open( Rails.root.to_s + "/config/transloadit.yml") )
    elsif Rails.env.development?
      transloadit_read = YAML::load( File.open( Rails.root.to_s + "/config/transloadit_dev.yml") )
    end




    auth_key = transloadit_read['auth']['key']
    auth_secret = transloadit_read['auth']['secret']
    duration = transloadit_read['auth']['duration']
    template = transloadit_read['templates'][template]

    params = JSON.generate({
      :auth => {
        :expires => (Time.now + duration).utc.strftime('%Y/%m/%d %H:%M:%S+00:00') ,
      # Time.now.utc.strftime('%Y/%m/%d %H:%M:%S+00:00'),
        :key => auth_key,
        :max_size => size_mb*1024*1024
      },
      :template_id => template 
    })


    digest = OpenSSL::Digest::Digest.new('sha1')
    signature = OpenSSL::HMAC.hexdigest(digest, auth_secret, params)
    [params, signature]
  end
  
  def compose_transloadit_upload_url(params, signature)
    TRANSLOADIT_UPLOAD_URL + "?params=#{params}&signature=#{signature}"
  end
  
=begin
  For printing numbers (money)
=end

  def print_money(value)
    number_with_delimiter( value , :delimiter => ",")
  end
=begin
  Date helper
=end

  def format_date_from_datetime( datetime) 
    if datetime.nil? 
      return ""
    end
    "#{datetime.month}/#{datetime.day}/#{datetime.year}"
  end
  
  
=begin
  Utility methods
=end

  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
  def create_guide(title, description)
    result = ""
    result << "<div class='explanation-unit'>"
    result << "<h1>#{title}</h1>"
    result << "<p>#{description}</p>"
    result << "</div>"
  end
  
  def create_breadcrumb(breadcrumbs)
    
    if (  breadcrumbs.nil? ) || ( breadcrumbs.length ==  0) 
      # no breadcrumb. don't create 
    else
      breadcrumbs_result = ""
      breadcrumbs_result << "<ul class='breadcrumb'>"
      
      puts "After the first"
      
      
      breadcrumbs[0..-2].each do |txt, path|
        breadcrumbs_result  << create_breadcrumb_element(    link_to( txt, path ) ) 
      end 
      
      puts "After the loop"
      
      last_text = breadcrumbs.last.first
      last_path = breadcrumbs.last.last
      breadcrumbs_result << create_final_breadcrumb_element( link_to( last_text, last_path)  )
      breadcrumbs_result << "</ul>"
      return breadcrumbs_result
    end
    
    
  end
  
  def create_breadcrumb_element( link ) 
    element = ""
    element << "<li>"
    element << link
    element << "<span class='divider'>/</span>"
    element << "</li>"
    
    return element 
  end
  
  def create_final_breadcrumb_element( link )
    element = ""
    element << "<li class='active'>"
    element << link 
    element << "</li>"
    
    return element
  end
  
  
=begin
  UTILITY CLASS FOR HIDING FORM 
=end
  def add_default_hidden(params)
    if params[:action] != 'create'
      return  'default-hidden'
    end
  end
  
=begin
  PROCESS NAVIGATION
=end
  def get_process_nav( symbol, params)
  
    if symbol == :company_admin_management
      return create_process_nav(COMPANY_ADMIN_MANAGEMENT_PROCESS_LIST, params )
    end
  
    if symbol == :project_setup
      return create_process_nav(PROJECT_SETUP_PROCESS_LIST, params )
    end
  
    if symbol == :project_management
      return create_process_nav(PROJECT_MANAGEMENT_PROCESS_LIST, params )
    end
  
    if symbol == :collaboration 
      return create_process_nav(COLLABORATION_PROCESS_LIST, params )
    end
  
    if symbol == :marketing_content 
      return create_process_nav(MARKETING_CONTENT_PROCESS_LIST, params )
    end
    
    if symbol == :teacher
      return create_process_nav(TEACHER_PROCESS_LIST, params )
    end
  
    if symbol == :submission_grading 
      return create_process_nav(SUBMISSION_GRADING_PROCESS_LIST, params )
    end
  
    if symbol == :student 
      return create_process_nav(STUDENT_PROCESS_LIST, params )
    end
  
    if symbol == :publisher
      return create_process_nav(PUBLISHER_PROCESS_LIST, params )
    end
  end
  
  protected
  #######################################################
  #####
  #####     Start of the process navigation code 
  #####
  #######################################################
  def create_process_nav( process_list, params )
    result = ""
    result << "<ul class='nav nav-list'>"
    result << "<li class='nav-header'>  "  + 
    process_list[:header_title] + 
    "</li>"         

    process_list[:processes].each do |process|
      result << create_process_entry( process, params )
    end

    result << "</ul>"

    return result
  end
   
  def create_process_entry( process, params )
    is_active = is_process_active?( process[:conditions], params)
    
    process_entry = ""
    process_entry << "<li class='#{is_active}'>" + 
                      link_to( process[:title] , extract_url( process[:destination_link] )    )
    
    return process_entry
  end
  
  def is_process_active?( active_conditions, params  )
    active_conditions.each do |condition|
      if condition[:controller] == params[:controller] &&
        condition[:action] == params[:action]
        return ACTIVE
      end

    end

    return ""
  end
  
  def extract_url( some_url )
    if some_url == '#'
      return '#'
    end
    
    eval( some_url ) 
  end
  
  #######################################################
  #####
  #####     Start of the process navigation KONSTANT
  #####
  #######################################################
  
  COMPANY_ADMIN_MANAGEMENT_PROCESS_LIST = {
    :header_title => "Manager",
    :processes => [
      {
        :title => "Add Employee",
        :destination_link => "new_employee_creation_url",
        :conditions => [
          {
            :controller => 'offices',
            :action => 'new_employee_creation'
          },
          {
            :controller => "offices",
            :action => 'create_employee'
          },
          {
            :controller => 'offices',
            :action => 'show_role_for_employee'
          }
        ]
      } ,
      {
        :title => "Create Deliverable",
        :destination_link => 'new_deliverable_url',
        :conditions => [
          {
            :controller => 'deliverables',
            :action => 'new'
          },
          {
            :controller => "deliverables",
            :action => "create"
          }
        ]
      },
      {
        :title => "Create Package",
        :destination_link => 'new_package_url',
        :conditions => [
          {
            :controller => 'packages',
            :action => 'new'
          },
          {
            :controller => "packages",
            :action => 'create'
          },
          {
            :controller => "package_assignments",
            :action => "new"
          }
        ]
      }
    ]
  }
  
  PUBLISHER_PROCESS_LIST = {
    :header_title => "Publisher",
    :processes => [
      {
        :title => "Create Article",
        :destination_link => "new_independent_article_url",
        :conditions => [
          {
            :controller =>'articles',
            :action => 'new'
          },
          {
            :controller => "articles",
            :action => "new_independent_article"
          }
        ]
      },
      {
        :title => "Finalize Article",
        :destination_link => "finalize_article_url",
        :conditions => [
          {
            :controller =>'articles',
            :action => 'finalize_article'
          },
          {
            :controller => "articles",
            :action => 'edit_article_content'
          },
          {
            :controller => "articles",
            :action => "edit_image_ordering"
          },
          {
            :controller => 'articles',
            :action => 'edit_publication'
          }
        ]
      }
    ]
  }
  
  
end
