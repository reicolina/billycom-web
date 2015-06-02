class BilledCall < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :orig_tn, :date, :time, :duration_sec, :destination, :dest_prov_state, :term_tn, :code, :amount_charged, :provider_id, :bill_id, :call_type
  belongs_to :site
  belongs_to :bill
end
