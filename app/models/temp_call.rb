class TempCall < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :orig_tn, :date, :time, :duration_sec, :destination, :dest_prov_state, :cc_ind, :ovs_ind, :term_tn, :code, :provider_charge, :provider_id
  belongs_to :site
  belongs_to :billing_session

  def get_call_type_info
    #First, check if there is something in the CC_IND field, 
    #if there is a valid Calling Card type then return it.
    #If not, then return whatever is in the OVS_IND field
    call_type_info = CallTypeInfo.search_abbreviation(self.cc_ind)
    if not call_type_info.nil?
      if call_type_info.is_calling_card
        call_type_info
      else  
        get_ovs_call_type_info
      end
    else
      get_ovs_call_type_info
    end
  end
  
  def get_ovs_call_type_info
    if self.ovs_ind.nil? or self.ovs_ind.length == 0
      Rails.logger.warn "WARNING: NIL or Blank OVS_IND"
      nil
      #if there is no ovs_ind then it is a non overseas call
      # CallTypeInfo.find_by_call_type(CallTypeInfo::NON_OVERSEAS) #<===We might want to check this. Althouhg this might never happen
    else
      type_info = CallTypeInfo.search_abbreviation(self.ovs_ind)
      if type_info.nil? || type_info.is_calling_card
        Rails.logger.warn "WARNING: Can't use a calling card call info for an OVS type. Can't use NIL type_info neither"
        nil #Can't use a calling card call info for an OVS type. Can't use NIL type_info neither
      else
        type_info
      end
    end    
  end
  
end

def generate_not_added_number_list_csv
  csv_string = CSV.generate do |csv| 
    TempCall.connection.select_rows("select DISTINCT orig_tn from temp_calls 
    where 
    stranded = 1 
    and orig_tn not in (select number from `lines`) " +
    "and `site_id` = " + ActsAsTenant.current_tenant.id.to_s +
    " order by orig_tn").each { |row| csv << row }
  end
  csv_string
end

def generate_not_added_call_type_list_csv
  csv_string = CSV.generate do |csv| 
    TempCall.connection.select_rows("select DISTINCT ovs_ind from temp_calls 
    where 
    stranded = 1 
    and orig_tn in (select number from `lines`)
    and ovs_ind is not NULL
    and length(ovs_ind) > 0
    and ovs_ind not in (select abbreviation from call_type_infos where is_calling_card = 0)
    and (cc_ind is null or length(cc_ind) = 0) " +
    "and `site_id` = " + ActsAsTenant.current_tenant.id.to_s +
    " order by ovs_ind").each { |row| csv << row }
  end
  csv_string
end

def generate_not_added_cc_call_type_list_csv
  csv_string = CSV.generate do |csv| 
    TempCall.connection.select_rows("select DISTINCT cc_ind from temp_calls 
    where 
    stranded = 1 
    and orig_tn in (select number from `lines`)
    and cc_ind is not NULL
    and length(cc_ind) > 0
    and cc_ind not in (select abbreviation from call_type_infos where is_calling_card = 1) " +
    "and `site_id` = " + ActsAsTenant.current_tenant.id.to_s +
    " order by cc_ind").each { |row| csv << row }
  end
  csv_string
end