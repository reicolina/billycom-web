# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131219191050) do

  create_table "accounts", :force => true do |t|
    t.boolean  "active"
    t.string   "account_number"
    t.string   "title"
    t.string   "address"
    t.string   "city"
    t.string   "province_or_state"
    t.string   "zip_or_postal_code"
    t.string   "billing_email"
    t.string   "main_contact_name"
    t.string   "main_contact_phone"
    t.string   "main_contact_fax"
    t.string   "main_contact_email"
    t.integer  "sales_rep_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "site_id"
  end

  create_table "accounts_taxes", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "tax_id"
  end

  create_table "adjustments", :force => true do |t|
    t.integer  "account_id"
    t.string   "description"
    t.decimal  "amount",      :precision => 8, :scale => 2
    t.date     "apply_on"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "site_id"
  end

  create_table "billed_adjustments", :force => true do |t|
    t.string   "description"
    t.decimal  "amount_charged", :precision => 8, :scale => 2
    t.integer  "bill_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "site_id"
  end

  create_table "billed_calls", :force => true do |t|
    t.string   "orig_tn"
    t.string   "date"
    t.string   "time"
    t.integer  "duration_sec"
    t.string   "destination"
    t.string   "term_tn"
    t.string   "code"
    t.decimal  "amount_charged",  :precision => 8, :scale => 4
    t.integer  "provider_id"
    t.integer  "bill_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "call_type"
    t.string   "dest_prov_state"
    t.integer  "site_id"
  end

  create_table "billed_lines", :force => true do |t|
    t.string   "number"
    t.string   "type_of_line"
    t.string   "use"
    t.string   "group"
    t.string   "sequence"
    t.decimal  "amount_charged", :precision => 8, :scale => 2
    t.integer  "bill_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "site_id"
  end

  create_table "billed_services", :force => true do |t|
    t.string   "type_of_service"
    t.string   "use"
    t.decimal  "amount_charged",  :precision => 8, :scale => 2
    t.integer  "bill_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "site_id"
  end

  create_table "billed_taxes", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",           :precision => 8, :scale => 2
    t.decimal  "amount_charged", :precision => 8, :scale => 4
    t.integer  "bill_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "site_id"
  end

  create_table "billing_sessions", :force => true do |t|
    t.string   "name"
    t.date     "billing_date"
    t.date     "due_date"
    t.integer  "start_number"
    t.boolean  "pending_flag"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "batch_email_status", :default => 0
    t.integer  "site_id"
    t.boolean  "processing_flag",    :default => false
    t.boolean  "failed",             :default => false
    t.string   "status"
    t.string   "csv",                :default => ""
  end

  create_table "billing_sessions_call_detail_records", :force => true do |t|
    t.integer "billing_session_id"
    t.integer "call_detail_record_id"
  end

  create_table "bills", :force => true do |t|
    t.integer  "number"
    t.integer  "account_id"
    t.integer  "billing_session_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "pending_flag",       :default => false
    t.boolean  "emailed",            :default => false
    t.integer  "site_id"
    t.string   "pdf",                :default => ""
    t.string   "csv",                :default => ""
  end

  create_table "call_detail_records", :force => true do |t|
    t.string   "name"
    t.integer  "provider_id"
    t.integer  "site_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "cdr"
  end

  create_table "call_type_infos", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "call_type"
    t.decimal  "fixed_rate",        :precision => 8, :scale => 4
    t.decimal  "cdr_charge_factor", :precision => 8, :scale => 2
    t.boolean  "is_calling_card"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "site_id"
  end

  add_index "call_type_infos", ["abbreviation"], :name => "index_call_type_infos_on_abbreviation"
  add_index "call_type_infos", ["call_type"], :name => "index_call_type_infos_on_call_type"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "international_plans", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "site_id"
  end

  create_table "international_rates", :force => true do |t|
    t.string   "code"
    t.string   "destination"
    t.decimal  "rate",                  :precision => 8, :scale => 4
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "international_plan_id"
    t.integer  "call_type"
    t.integer  "site_id"
    t.integer  "increment_in_seconds",                                :default => 1
  end

  add_index "international_rates", ["code", "international_plan_id"], :name => "index_international_rates_on_code_and_international_plan_id"

  create_table "lines", :force => true do |t|
    t.integer  "account_id"
    t.boolean  "active"
    t.string   "number"
    t.string   "type_of_line"
    t.string   "use"
    t.string   "group"
    t.integer  "sequence"
    t.decimal  "line_rate",      :precision => 8, :scale => 2
    t.date     "port_date"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "rating_plan_id"
    t.integer  "site_id"
  end

  add_index "lines", ["number"], :name => "index_lines_on_number"

  create_table "local_plans", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",                 :precision => 8, :scale => 4
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "site_id"
    t.integer  "increment_in_seconds",                               :default => 1
  end

  create_table "minimum_charge_ratings", :force => true do |t|
    t.string   "name"
    t.decimal  "duration_sec",         :precision => 10, :scale => 0
    t.decimal  "percentage",           :precision => 8,  :scale => 2
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.decimal  "fixed_minimum_charge", :precision => 8,  :scale => 4, :default => 0.0
    t.integer  "site_id"
  end

  create_table "other_services", :force => true do |t|
    t.integer  "account_id"
    t.string   "type_of_service"
    t.string   "use"
    t.decimal  "rate",            :precision => 8, :scale => 2
    t.date     "port_date"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "site_id"
  end

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.integer  "orig_tn"
    t.integer  "date"
    t.integer  "time"
    t.integer  "duration_sec"
    t.integer  "destination"
    t.integer  "cc_ind"
    t.integer  "ovs_ind"
    t.integer  "term_tn"
    t.integer  "code"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "provider_charge"
    t.integer  "destination_prov_state"
    t.boolean  "has_header"
    t.integer  "ovs_ind2"
    t.boolean  "convert_from_minutes"
    t.string   "default_call_type"
    t.integer  "destination1"
    t.integer  "destination_prov_state1"
    t.integer  "term_tn1"
    t.boolean  "date_contains_time",      :default => false
    t.string   "prefixes"
    t.string   "call_type_abbreviation"
    t.string   "prefixes1"
    t.string   "call_type_abbreviation1"
    t.integer  "site_id"
  end

  create_table "rating_plans", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "international_plan_id"
    t.integer  "local_plan_id"
    t.integer  "minimum_charge_rating_id"
    t.decimal  "cdr_charge_factor",        :precision => 8, :scale => 2
    t.integer  "site_id"
  end

  create_table "sales_reps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "site_id"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.binary   "logo"
    t.datetime "created_at",                                                                          :null => false
    t.datetime "updated_at",                                                                          :null => false
    t.string   "logo_type"
    t.string   "logo_filename"
    t.boolean  "show_logo_on_print"
    t.string   "address"
    t.string   "city"
    t.string   "province_or_state"
    t.string   "postal_or_zip_code"
    t.string   "country"
    t.string   "bill_inquiries_line_1"
    t.string   "bill_inquiries_line_2"
    t.string   "bill_inquiries_line_3"
    t.string   "slip_notes_line_1"
    t.string   "slip_notes_line_2"
    t.string   "slip_notes_line_3"
    t.string   "slip_notes_line_4"
    t.text     "email_body_text"
    t.string   "from_email"
    t.boolean  "cc_yourself"
    t.string   "invoice_number_text",     :default => "Invoice Number"
    t.string   "invoice_date_text",       :default => "Invoice Date"
    t.string   "invoice_slip_title",      :default => "                         Payment Return Slip"
    t.boolean  "show_due_date",           :default => true
    t.boolean  "show_amount_due_section", :default => true
    t.string   "bill_inquiries_title",    :default => "Bill Inquiries"
    t.string   "billed_number_title",     :default => "Number"
    t.string   "to_from_number_title",    :default => "Destination #"
    t.string   "to_from_title",           :default => "Destination"
    t.string   "duration_title",          :default => "Dur(hh:mm:ss)"
    t.string   "charge_title",            :default => "Charge"
    t.string   "number_group_by_text",    :default => "Phone Number"
    t.string   "currency_symbol",         :default => "$"
    t.binary   "logo2"
    t.string   "logo2_type"
    t.string   "logo2_filename"
    t.integer  "logo2_x_position"
    t.integer  "logo2_y_position"
    t.integer  "decimals",                :default => 2
  end

  create_table "taxes", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",       :precision => 8, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "site_id"
  end

  create_table "temp_calls", :force => true do |t|
    t.string   "orig_tn"
    t.string   "date"
    t.string   "time"
    t.integer  "duration_sec"
    t.string   "destination"
    t.string   "cc_ind"
    t.string   "ovs_ind"
    t.string   "term_tn"
    t.string   "code"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "account_id"
    t.decimal  "amount_charged",     :precision => 8, :scale => 4
    t.integer  "billing_session_id"
    t.integer  "provider_id"
    t.decimal  "provider_charge",    :precision => 8, :scale => 4
    t.boolean  "rated",                                            :default => false
    t.boolean  "stranded",                                         :default => false
    t.string   "call_type"
    t.string   "dest_prov_state"
    t.integer  "site_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.datetime "last_request_at"
    t.integer  "site_id"
    t.boolean  "admin"
  end

end
