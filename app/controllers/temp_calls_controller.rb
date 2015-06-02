class TempCallsController < ApplicationController
  layout "application"
  
  require 'csv'  
  
  def download_not_added_number_list_csv
    send_data generate_not_added_number_list_csv, :type => "text/csv", :filename => ("NumbersToBeAdded").titleize.gsub(/ /,'') + ".csv"
  end
  
  def download_not_added_call_type_list_csv
    send_data generate_not_added_call_type_list_csv, :type => "text/csv", :filename => ("CallTypesToBeAdded").titleize.gsub(/ /,'') + ".csv"
  end
  
  def download_not_added_cc_call_type_list_csv
    send_data generate_not_added_cc_call_type_list_csv, :type => "text/csv", :filename => ("CCCallTypesToBeAdded").titleize.gsub(/ /,'') + ".csv"
  end
  
  def fast_import
      @provider = Provider.find(params[:provider][:id])
      # success = false
      begin
        if not (params[:dump]).nil?
          # data = params[:dump][:file].read    
          @provider.import_cdr(params[:dump][:file].read, @provider.id)  
          # @parsed_file=CSV.parse(data, :headers => @provider.has_header)
          # @provider.import_usage(@parsed_file)
          flash[:notice] = "CDR is now queued to be imported"
          # success = true
        else
          flash[:warning] = "You must choose a CDR file to import!"
        end
      rescue => e
        log_error(e)
        flash[:warning] = "Error while importing CDR file"
        # flash[:warning] = "Invalid or malformed CDR file"
      end
      # if success == true
        # temp_call = TempCall.find(:last)
        # respond_to do |format|
        #    format.html { redirect_to(temp_call) }
        # end
      # else
        respond_to do |format|
           format.html { redirect_to(temp_calls_url) }
        end
      # end
  end
  
  # GET /temp_calls
  # GET /temp_calls.xml
  def index
    @new_usage_count = TempCall.count(:conditions => {:stranded => false})
    @stranded_usage_count_good = TempCall.count(:conditions => "stranded = 1 and orig_tn not in (select number from `lines`)")
    @stranded_usage_count_bad = TempCall.count(:conditions => "stranded = 1 
                                                                and orig_tn in (select number from `lines`)
                                                                and not (
                                                                	orig_tn in (select number from `lines`)
                                                                	and ovs_ind is not NULL
                                                                	and length(ovs_ind) > 0
                                                                	and ovs_ind not in (select abbreviation from call_type_infos where is_calling_card = 0)
                                                                	and (cc_ind is null or length(cc_ind) = 0)
                                                                )
                                                                and not (
                                                                	orig_tn in (select number from `lines`)
                                                                	and cc_ind is not NULL
                                                                	and length(cc_ind) > 0
                                                                	and cc_ind not in (select abbreviation from call_type_infos where is_calling_card = 1)
                                                                )")
    @stranded_usage_count_bad1 = TempCall.count(:conditions => "stranded = 1 
                                                                and orig_tn in (select number from `lines`)
                                                                and ovs_ind is not NULL
                                                                and length(ovs_ind) > 0
                                                                and ovs_ind not in (select abbreviation from call_type_infos where is_calling_card = 0)
                                                                and (cc_ind is null or length(cc_ind) = 0)")
    @stranded_usage_count_bad2 = TempCall.count(:conditions => "stranded = 1 
                                                                and orig_tn in (select number from `lines`)
                                                                and cc_ind is not NULL
                                                                and length(cc_ind) > 0
                                                                and cc_ind not in (select abbreviation from call_type_infos where is_calling_card = 1)")
    @pending_billing_sessions = BillingSession.count(:conditions => {:pending_flag => true})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp_calls }
    end
  end

  # GET /temp_calls/1
  # GET /temp_calls/1.xml
  def show
    @temp_calls = TempCall.find(:all,:order => "id DESC", :limit => 10)
    @new_usage_count = TempCall.count(:conditions => {:stranded => false})
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp_call }
    end
  end
  
  def delete_new_records
    TempCall.delete_all(:stranded => false)
    respond_to do |format|
      format.html { redirect_to(temp_calls_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_stranded_good_records
    TempCall.delete_all("stranded = 1 and orig_tn not in (select number from `lines`)")
    respond_to do |format|
      format.html { redirect_to(temp_calls_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_stranded_bad_records
    TempCall.delete_all("stranded = 1 
                          and not (
                          	orig_tn in (select number from `lines`)
                          	and ovs_ind is not NULL
                          	and length(ovs_ind) > 0
                          	and ovs_ind not in (select abbreviation from call_type_infos where is_calling_card = 0)
                          	and (cc_ind is null or length(cc_ind) = 0)
                          )
                          and not (
                          	orig_tn in (select number from `lines`)
                          	and cc_ind is not NULL
                          	and length(cc_ind) > 0
                          	and cc_ind not in (select abbreviation from call_type_infos where is_calling_card = 1)
                          )")
    respond_to do |format|
      format.html { redirect_to(temp_calls_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_stranded_bad_records1
    TempCall.delete_all("stranded = 1 
                          and orig_tn in (select number from `lines`)
                          and ovs_ind is not NULL
                          and length(ovs_ind) > 0
                          and ovs_ind not in (select abbreviation from call_type_infos where is_calling_card = 0)
                          and (cc_ind is null or length(cc_ind) = 0)")
    respond_to do |format|
      format.html { redirect_to(temp_calls_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_stranded_bad_records2
    TempCall.delete_all("stranded = 1 
                          and orig_tn in (select number from `lines`)
                          and cc_ind is not NULL
                          and length(cc_ind) > 0
                          and cc_ind not in (select abbreviation from call_type_infos where is_calling_card = 1)")
    respond_to do |format|
      format.html { redirect_to(temp_calls_url) }
      format.xml  { head :ok }
    end
  end
  
end
