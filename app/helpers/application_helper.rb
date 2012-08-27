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
  
  
  
  def select_hour_options
    array = ""
    (0..23).each do |x|
      array << "<option>#{x}</option>"
    end
    return array 
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
      
      
      
      breadcrumbs[0..-2].each do |txt, path|
        breadcrumbs_result  << create_breadcrumb_element(    link_to( txt, path ) ) 
      end 
      
      
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
   
    if symbol == :employee_management
      return create_process_nav(EMPLOYEE_MANAGEMENT_PROCESS_LIST, params )
    end
    if symbol == :product_management
      return create_process_nav(PRODUCT_MANAGEMENT_PROCESS_LIST, params )
    end
    if symbol == :supplier_management
      return create_process_nav( SUPPLIER_MANAGEMENT_PROCESS_LIST, params )
    end
    
    if symbol == :marketing_management
      return create_process_nav( MARKETING_MANAGEMENT_PROCESS_LIST, params )
    end
    
    
    if symbol == :marketing
      return create_process_nav(MARKETING_PROCESS_LIST, params )
    end
  
    if symbol == :sales_order_creation
      return create_process_nav(SALES_ORDER_PROCESS_LIST, params )
    end
  
    if symbol == :project_management_head
      return create_process_nav(PROJECT_MANAGEMENT_HEAD_PROCESS_LIST, params )
    end
    
    if symbol == :project_management 
      return create_process_nav(PROJECT_MANAGEMENT_PROCESS_LIST, params )
    end
    
    if symbol == :account_executive 
      return create_process_nav(ACCOUNT_EXECUTIVE_PROCESS_LIST, params )
    end
    
    if symbol == :graphic_designer 
      return create_process_nav(GRAPHIC_DESIGNER_PROCESS_LIST, params )
    end
  
    if symbol == :post_production 
      return create_process_nav(POST_PRODUCTION_PROCESS_LIST, params )
    end
  
    if symbol == :marketing_content 
      return create_process_nav(MARKETING_CONTENT_PROCESS_LIST, params )
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
  
  
 

  EMPLOYEE_MANAGEMENT_PROCESS_LIST = {
    :header_title => "Employee", 
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
      }
    ]
  }
  
  PRODUCT_MANAGEMENT_PROCESS_LIST = {
    :header_title => "Products", 
    :processes => [
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
          },
          {
            :controller => 'deliverable_subcriptions',
            :action => 'new'
          },
          {
            :controller => 'deliverable_subcriptions',
            :action => 'create'
          }
        ]
      }
    ]
  }
  
  SUPPLIER_MANAGEMENT_PROCESS_LIST = {
    :header_title => "Supplier", 
    :processes => [
      {
        :title => "Create Supplier", 
        :destination_link => "new_supplier_url",
        :conditions => [
          {
            :controller => 'suppliers',
            :action => 'new'
          },
          {
            :controller => "suppliers",
            :action => 'create'
          } 
        ]
      }
    ]
  }

  
  
  MARKETING_MANAGEMENT_PROCESS_LIST = {
    :header_title => "S&M Management", 
    :processes => [
      {
        :title => "Employee Performance", 
        :destination_link => "select_employee_to_view_marketing_performance_url",
        :conditions => [
          {
            :controller => 'offices',
            :action => 'select_employee_to_view_marketing_performance'
          },
          {
            :controller => "offices",
            :action => 'marketing_performance_for'
          } 
        ]
      },
      {
        :title => "Customer Engagement", 
        :destination_link => "customer_engagements_url",
        :conditions => [
          {
            :controller => 'offices',
            :action => 'customer_engagements'
          } 
        ]
      },
      {
        :title => "Sales Summary", 
        :destination_link => "sales_summary_url",
        :conditions => [
          {
            :controller => 'offices',
            :action => 'sales_summary'
          } 
        ]
      }
      
    ]
  }
  
  MARKETING_PROCESS_LIST = {
    :header_title => "Marketing",
    :processes => [
      {
        :title => "Client",
        :destination_link => "new_client_url",
        :conditions => [
          {
            :controller =>'clients',
            :action => 'new'
          },
          {
            :controller => "clients",
            :action => "create"
          },
          {
            :controller => "contact_reports",
            :action => "index"
          },
          {
            :controller => "sales_orders",
            :action => 'index'
          },
          {
            :controller => "important_events",
            :action => "index"
          }
        ]
      },
      {
        :title => "Marketing Interaction",
        :destination_link => "search_client_for_marketing_interaction_url",
        :conditions => [
          {
            :controller =>'clients',
            :action => 'search_client_for_marketing_interaction'
          } ,
          {
            :controller => 'contact_reports',
            :action =>'new'
          },
          {
            :controller => "contact_reports",
            :action => 'create'
          },
          {
            :controller => 'sales_orders',
             :action => 'show_all_past_purchases_for_client'
          },
          {
            :controller => "important_events",
            :action => "new"
          },
          {
            :controller => "important_events",
            :action => "create"
          }
        ]
      },
      {
        :title => "Event Reminder",
        :destination_link => "all_important_events_url",
        :conditions => [
          {
            :controller =>'important_events',
            :action => 'all_important_events'
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
  
  
  SALES_ORDER_PROCESS_LIST = {
    :header_title => "Sales Order",
    :processes => [
      {
        :title => "Single Package Sales Order",
        :destination_link => "search_client_for_single_package_sales_order_url",
        :conditions => [
          {
            :controller =>'clients',
            :action => 'search_client_for_single_package_sales_order'
          },
          {
            :controller => "packages",
            :action => "select_package_for_single_package_sales_order"
          },
          {
            :controller => "projects",
            :action => 'book_crew_for_single_package_sales_order'
          },
          {
            :controller => "projects",
            :action => 'select_crew_to_be_booked'
          },
          {
            :controller => 'projects', 
            :action => 'execute_crew_booking_for_single_package_sales_order'
          },
          {
            :controller => 'sales_orders',
            :action => 'single_package_sales_order_finalization'
          },
          {
            :controller => 'sales_orders',
            :action => 'create_new_deliverable_item_from_single_package_sales_order_finalization'
          },
          {
            :controller => 'sales_orders',
            :action => 'finalize_sales_order_single_package'
          },
          {
            :controller => 'sales_orders',
            :action => 'single_package_sales_order_finalized'
          }
        ]
      },
      {
        :title => "Pending Confirmation",
        :destination_link => "pending_confirmation_sales_orders_url",
        :conditions => [
          {
            :controller =>'offices',
            :action => 'pending_confirmation_sales_orders'
          } 
        ]
      },
      # download receipt? yeah right  
      {
        :title => "Confirmed Sales Order",
        :destination_link => "confirmed_unfinalized_sales_orders_url",
        :conditions => [
          {
            :controller =>'offices',
            :action => 'confirmed_unfinalized_sales_orders'
          } 
        ]
      },
      {
        :title => "Crew Calendar",
        :destination_link => "select_crew_to_view_calendar_url",
        :conditions => [
          {
            :controller =>'offices',
            :action => 'select_crew_to_view_calendar'
          } ,
          {
            :controller => 'job_requests', 
            :action => 'crew_schedule'
          }
        ]
      },
      {
        :title => "All Crew Calendar",
        :destination_link => "show_all_bookings_url",
        :conditions => [
          {
            :controller =>'offices',
            :action => 'show_all_bookings'
          } 
        ]
      }
    ]
  }
  
  
  
  
  PROJECT_MANAGEMENT_HEAD_PROCESS_LIST = {
    :header_title => "Head Project Manager",
    :processes => [
      {
        :title => "Employee Assignment",
        :destination_link => "select_project_for_project_membership_assignment_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_for_project_membership_assignment'
          },
          {
            :controller => 'projects',
            :action => 'select_role_to_assign_employee'
          },
          {
            :controller => "project_memberships",
            :action => 'new'
          },
          {
            :controller => "project_memberships",
            :action => 'assign_member_with_selected_project_role_to_project'
          }
        ]
      },
      {
        :title => "Pending Start",
        :destination_link => "select_project_to_be_started_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_be_started'
          } 
        ]
      } ,
      {
        :title => "Monitor Projects + Close",
        :destination_link => "select_project_to_be_closed_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_be_closed'
          } 
        ]
      },
      {
        :title => "Finished Project",
        :destination_link => "show_finished_projects_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'show_finished_projects'
          } 
        ]
      }
    ]
  }
  
  PROJECT_MANAGEMENT_PROCESS_LIST = {
    :header_title => "Project Management",
    :processes => [
      {
        :title => "Schedule Production",
        :destination_link => "select_project_to_be_scheduled_in_production_mode_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_be_scheduled_in_production_mode'
          } ,
          {
            :controller =>'drafts',
            :action => 'assign_deadline_for_draft'
          }
        ]
      },
      {
        :title => "Schedule Post Production",
        :destination_link => "select_project_to_be_scheduled_in_post_production_mode_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_be_scheduled_in_post_production_mode'
          } ,
          {
            :controller => 'projects',
            :action => 'assign_deadline_for_post_production'
          },
          {
            :controller => 'job_requests',
            :action => 'create_post_production_job_request'
          }
        ]
      }
    ]
  }
  
  
  ACCOUNT_EXECUTIVE_PROCESS_LIST = {
    :header_title => "Account Executive",
    :processes => [
      {
        :title => "Pre Production Management",
        :destination_link => "finalize_article_url",
        :conditions => [
          {
            :controller =>'',
            :action => ''
          } 
        ]
      },
      {
        :title => "Production Management",
        :destination_link => "select_project_to_manage_production_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_manage_production'
          } ,
          {
            :controller => 'drafts',
            :action => 'new'
          },
          {
            :controller => 'drafts',
            :action => 'create'
          },
          {
            :controller => 'tasks',
            :action => 'new'
          },
          {
            :controller => 'tasks',
            :action => 'create'
          }
          
        ]
      },
      {
        :title => "Post Production Management",
        :destination_link => "select_project_to_monitor_post_production_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_monitor_post_production'
          }
        ]
      },
      {
        :title => "Finished Projects",
        :destination_link => "finalize_article_url",
        :conditions => [
          {
            :controller =>'',
            :action => ''
          } 
        ]
      }
    ]
  }
  
  GRAPHIC_DESIGNER_PROCESS_LIST = {
    :header_title => "Production", 
    :processes => [
      {
        :title => "Assigned Projects", 
        :destination_link => "list_of_assigned_production_project_url",
        :conditions => [
          {
            :controller => 'projects',
            :action => 'list_of_assigned_production_project'
          } ,
          {
            :controller => 'drafts',
            :action => 'show_detail_draft_brief'
          }
        ]
      },
      {
        :title => "Production Schedule", 
        :destination_link => 'show_production_calendar_url',
        :conditions => [
          {
            :controller => 'job_requests',
            :action => 'show_production_calendar'
          }
        ]
      }
    ]
  }
  
  POST_PRODUCTION_PROCESS_LIST = {
    :header_title => "Post Production",
    :processes => [
      {
        :title => "Manage Post Production",
        :destination_link => "select_project_to_update_production_progress_url",
        :conditions => [
          {
            :controller =>'projects',
            :action => 'select_project_to_update_production_progress'
          },
          {
            :controller => 'deliverable_items',
            :action => 'select_deliverable_to_update_progress'
          }, # start the deliverable item creation
          {
            :controller => 'deliverable_items',
            :action => 'start_deliverable_item_creation'
          },
          {
            :controller => 'deliverable_items',
            :action => 'execute_start_deliverable_item_creation'
          },# start the retrieval of deliverable item from subcon
          {
            :controller => 'deliverable_items',
            :action => 'finish_deliverable_item_creation'
          },
          {
            :controller => 'deliverable_items',
            :action => 'execute_finish_deliverable_item_creation'
          },# deliver the item to client 
          {
            :controller => 'deliverable_items',
            :action => 'deliver_deliverable_item_creation'
          },
          {
            :controller => 'deliverable_items',
            :action => 'execute_deliver_deliverable_item_creation'
          }
        ]
      },
      {
        :title => "Pending Start",
        :destination_link => "deliverable_items_pending_start_url",
        :conditions => [
          {
            :controller =>'deliverable_items',
            :action => 'deliverable_items_pending_start'
          } 
        ]
      },
      {
        :title => "Pending Finish",
        :destination_link => "deliverable_items_pending_finish_url",
        :conditions => [
          {
            :controller =>'deliverable_items',
            :action => 'deliverable_items_pending_finish'
          } 
        ]
      },
      {
        :title => "Pending Delivery",
        :destination_link => "deliverable_items_pending_delivery_url",
        :conditions => [
          {
            :controller =>'deliverable_items',
            :action => 'deliverable_items_pending_delivery'
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
