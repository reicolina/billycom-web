class ApplicationController < ActionController::Base
  protect_from_forgery
  set_current_tenant_through_filter
  before_filter :require_user
  before_filter :find_current_tenant
  helper_method :current_user
  
  # # Background Job Methods
  # # ======================
  # def call_rake(task, options = {})
  #   options[:rails_env] = Rails.env
  #   args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
  #   #system "$rvm_path/bin/rake #{task} #{args.join(' ')} &"
  #   system "rake #{task} #{args.join(' ')} &"
  #   # system "/usr/bin/rake #{task} #{args.join(' ')} &"
  # end
  
  # Multi-Tenancy Methods
  # =====================

  def find_current_tenant
    if not current_user.nil?
      current_site = Site.find(current_user.site.id)
      set_current_tenant(current_site)
    end
  end
  
  # Authentication Methods
  # ======================
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def check_master
    authenticate_or_request_with_http_basic("Users") do |username, password|
      hashed_password = Digest::SHA512.hexdigest(password)
      username == Source::Application.config.master_user && hashed_password == Source::Application.config.master_hash
    end
  end
  
  # Error Handling Methods
  # ======================
  
  def log_error(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
  end
  
  # Default Model Creation Methods
  #===============================
  
  def populate_default_site(site_id)
    Rails.logger.info "SITE_CREATION_LOG: site_id is " + site_id.to_s
    # Taxes
    tax = Tax.new({ :site_id => site_id, :name => 'TAX(10%)', :rate => '10' }, :without_protection => true)
    tax.save
    Rails.logger.info "SITE_CREATION_LOG: tax_site_id is " + tax.site_id.to_s + " and site_id is " + site_id.to_s
    # tax = nil
    # Sales Reps
    sales_rep = SalesRep.new({ :site_id => site_id, :name => 'Test Rep' }, :without_protection => true)
    sales_rep.save
    Rails.logger.info "SITE_CREATION_LOG: sales_rep_site_id is " + sales_rep.site_id.to_s + " and site_id is " + site_id.to_s
    # sales_rep = nil
    # Call Types
    call_type = CallTypeInfo.new({ :site_id => site_id, :name => 'Intra/Interlata', :abbreviation => 'ILE', :call_type => 0, :cdr_charge_factor => 1 }, :without_protection => true)
    call_type.save
    call_type = CallTypeInfo.new({ :site_id => site_id, :name => 'Interstate', :abbreviation => 'INE', :call_type => 0, :cdr_charge_factor => 1 }, :without_protection => true)
    call_type.save
    Rails.logger.info "SITE_CREATION_LOG: call_type_site_id is " + call_type.site_id.to_s + " and site_id is " + site_id.to_s
    # call_type = nil
    # Providers
    provider = Provider.new({:site_id => site_id, :name => 'Test Provider', :orig_tn => 10, :date => 22, :time => 23, :duration_sec => 27, :destination => 40, :ovs_ind => 42, :term_tn => 13, :provider_charge => 46, :destination_prov_state => 41}, :without_protection => true)
    provider.save
    Rails.logger.info "SITE_CREATION_LOG: provider_site_id is " + provider.site_id.to_s + " and site_id is " + site_id.to_s
    # provider = nil
    # Local Plans
    local_plan = LocalPlan.new({:site_id => site_id, :name => 'Default Long Distance', :rate => '0.032'}, :without_protection => true)
    local_plan.save
    Rails.logger.info "SITE_CREATION_LOG: local_plan_site_id is " + local_plan.site_id.to_s + " and site_id is " + site_id.to_s
    # local_plan = nil
    # International Plans
    international_plan = InternationalPlan.new({:site_id => site_id, :name => 'Default International Plan'}, :without_protection => true)
    international_plan.save
    Rails.logger.info "SITE_CREATION_LOG: international_plan_site_id is " + international_plan.site_id.to_s + " and site_id is " + site_id.to_s
    # international_plan = nil
    # Minimum Charges
    minimum_charge = MinimumChargeRating.new({:site_id => site_id, :name => 'Default Minimum Charge', :duration_sec => 1, :percentage => 1}, :without_protection => true)
    minimum_charge.save
    Rails.logger.info "SITE_CREATION_LOG: minimum_charge_site_id is " + minimum_charge.site_id.to_s + " and site_id is " + site_id.to_s
    # minimum_charge = nil
    # Long Distance Plan
    long_distance_plan = RatingPlan.new({:site_id => site_id, :name => 'Default Long Distance Plan', :international_plan => InternationalPlan.find(:first, :conditions => [ "site_id = ?", site_id]), :local_plan => LocalPlan.find(:first, :conditions => [ "site_id = ?", site_id]), :minimum_charge_rating => MinimumChargeRating.find(:first, :conditions => [ "site_id = ?", site_id])}, :without_protection => true)
    long_distance_plan.save
    Rails.logger.info "SITE_CREATION_LOG: long_distance_plan_site_id is " + long_distance_plan.site_id.to_s + " and site_id is " + site_id.to_s
    # long_distance_plan= nil
    # Clients
    client = Account.new({:site_id => site_id, :active => true, :account_number => 'TST0000123', :title => 'Test Client', :address => '123 Test St', :city => 'Test City', :province_or_state => 'BC', :zip_or_postal_code => '12345', :sales_rep => SalesRep.find(:first, :conditions => [ "site_id = ?", site_id]), :taxes => [Tax.find(:first, :conditions => [ "site_id = ?", site_id])]}, :without_protection => true)
    client.save
    # client = nil
    # Lines
    line = Line.new({:site_id => site_id, :active => true, :number => '6041111111', :type_of_line => 'Single Line', :line_rate => '35', :rating_plan => RatingPlan.find(:first, :conditions => [ "site_id = ?", site_id]), :port_date => '2012-01-01', :account => Account.find(:first, :conditions => [ "site_id = ?", site_id])}, :without_protection => true)
    line.save
    line = Line.new({:site_id => site_id, :active => true, :number => '6041112222', :type_of_line => 'Single Line', :line_rate => '35', :rating_plan => RatingPlan.find(:first, :conditions => [ "site_id = ?", site_id]), :port_date => '2012-01-01', :account => Account.find(:first, :conditions => [ "site_id = ?", site_id])}, :without_protection => true)
    line.save
    line = Line.new({:site_id => site_id, :active => true, :number => '6041113333', :type_of_line => 'Single Line', :line_rate => '35', :rating_plan => RatingPlan.find(:first, :conditions => [ "site_id = ?", site_id]), :port_date => '2012-01-01', :account => Account.find(:first, :conditions => [ "site_id = ?", site_id])}, :without_protection => true)
    line.save        
    # line = nil
    # Services
    other_service = OtherService.new({:site_id => site_id, :type_of_service => 'Voice Mail', :use => 'Main', :rate => '10', :port_date => '2012-01-01', :account => Account.find(:first, :conditions => [ "site_id = ?", site_id])}, :without_protection => true)
    other_service.save
    # other_service = nil
  end
  
end
