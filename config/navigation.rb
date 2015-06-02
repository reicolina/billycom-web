# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'
  navigation.selected_class = 'current_page_item'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>. 
    #
    # primary.item :key_1, 'name', url, options
    
    primary.item :accounts, 'Clients', accounts_path, :if => Proc.new { current_user } do |accounts|
      accounts.item :new_client, 'New Client', new_account_path, :highlights_on => /accounts/
      accounts.item :all_clients, 'Show All Clients', accounts_path + "?search_string=", :highlights_on => /accounts/
    end
    
    primary.item :billing, 'Billing', billing_sessions_path, :if => Proc.new { current_user } do |billing|
      billing.item :billing_sessions, 'Billing Sessions', billing_sessions_path, :highlights_on => /(\/billing_sessions)|(\/bills)/
      billing.item :call_detail_records, 'Call Detail Records', call_detail_records_path, :highlights_on => /call_detail_records/
      billing.item :stranded_calls, 'Stranded Calls', temp_calls_path, :highlights_on => /temp_calls/
    end

    # Add an item which has a sub navigation (same params, but with block)
    primary.item :settings, 'Settings', company_path, :if => Proc.new { current_user } do |settings|
      # Add an item to the sub navigation (same params again)
      settings.item :company, 'Company', company_path, :highlights_on => /sites/
      settings.item :taxes, 'Taxes', taxes_path, :highlights_on => /taxes/
      settings.item :sales_reps, 'Sales Representatives', sales_reps_path, :highlights_on => /sales_reps/
      settings.item :call_types, 'Call Types', call_type_infos_path, :highlights_on => /call_type_infos/
      settings.item :providers, 'Providers', providers_path, :highlights_on => /providers/
      settings.item :local_rates, 'Local Rates', local_plans_path, :highlights_on => /local_plans/
      settings.item :international_rates, 'International Rates', international_plans_path, :highlights_on => /(\/international_plans)|(\/international_rates)/
      settings.item :call_minimum_charges, 'Call Minimum Charges', minimum_charge_ratings_path, :highlights_on => /minimum_charge_ratings/
      settings.item :long_distance_plans, 'Long Distance Plans', rating_plans_path, :highlights_on => /rating_plans/
    end
        
    primary.item :admin, 'Admin', admin_path, :unless => Proc.new { current_user } do |admin|
       admin.item :companies, 'Companies', sites_path, :highlights_on => /sites/
       admin.item :users, 'Users', users_path, :highlights_on => /users/
    end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end
