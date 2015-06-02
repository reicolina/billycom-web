Source::Application.routes.draw do
  
  resources :call_detail_records


  # Singular Resources
  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'
  match 'admin' => 'sites#index'
  match 'company' => 'sites#settings'
  match 'calls_fast_import' => 'temp_calls#fast_import'
  match 'calls_delete_new_records' => 'temp_calls#delete_new_records'
  match 'calls_download_not_added_number_list_csv' => 'temp_calls#download_not_added_number_list_csv'
  match 'calls_delete_stranded_good_records' => 'temp_calls#delete_stranded_good_records'
  match 'calls_download_not_added_call_type_list_csv' => 'temp_calls#download_not_added_call_type_list_csv'
  match 'calls_delete_stranded_bad_records1' => 'temp_calls#delete_stranded_bad_records1'
  match 'calls_download_not_added_cc_call_type_list_csv' => 'temp_calls#download_not_added_cc_call_type_list_csv'
  match 'calls_delete_stranded_bad_records2' => 'temp_calls#delete_stranded_bad_records2'
  match 'calls_delete_stranded_bad_records' => 'temp_calls#delete_stranded_bad_records'
  match "/delayed_job" => DelayedJobWeb, :anchor => false
  
  resources :user_sessions
  resources :users
  resources :call_type_infos
  resources :rating_plans
  resources :minimum_charge_ratings
  resources :local_plans
  resources :temp_calls
  resources :providers
  resources :international_rates
  resources :adjustments
  resources :other_services
  resources :lines
  resources :taxes
  resources :sales_reps
  
  resources :sites do
    member do
      post 'delete_logo1'
      post 'delete_logo2'
      post 'bill_preview'
      get 'code_image'
      get 'code_image2'
    end
  end
  
  resources :international_plans do
    member do
      post 'import'
    end
  end
  
  resources :accounts do
    resources :lines
    resources :other_services
    resources :adjustments
  end
  
  resources :billing_sessions do
    resources :bills
    member do
      # post 'export_csv'
      get 'batch_email'
    end
  end
  
  resources :bills do
    resources :billed_taxes
    resources :billed_adjustments
    resources :billed_lines
    resources :billed_calls
    resources :billed_services
    member do
      # post "get_invoice"
      # post "export_csv"
      post 'email_invoice'
    end
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root:to => redirect('/accounts')

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
