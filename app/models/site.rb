class Site < ActiveRecord::Base
  attr_accessible :name, :address, :city, :id, :province_or_state, :postal_or_zip_code, :country, :currency_symbol, :bill_inquiries_title, :bill_inquiries_line_1, :bill_inquiries_line_2, :bill_inquiries_line_3, :invoice_number_text, :invoice_date_text, :show_due_date, :show_amount_due_section, :invoice_slip_title, :slip_notes_line_1, :slip_notes_line_2, :slip_notes_line_3, :slip_notes_line_4, :number_group_by_text, :billed_number_title, :to_from_number_title, :to_from_title, :duration_title, :charge_title, :from_email, :email_body_text, :logo2_x_position, :logo2_y_position, :show_logo_on_print, :logo_file, :logo2_file, :decimals
  has_many :users, :dependent => :destroy
  has_many :taxes, :dependent => :destroy
  has_many :accounts, :dependent => :destroy
  has_many :lines, :dependent => :destroy
  has_many :other_services, :dependent => :destroy
  has_many :adjustments, :dependent => :destroy
  has_many :sales_reps, :dependent => :destroy
  has_many :call_type_infos, :dependent => :destroy
  has_many :providers, :dependent => :destroy
  has_many :rating_plans, :dependent => :destroy
  has_many :local_plans, :dependent => :destroy
  has_many :international_plans, :dependent => :destroy
  has_many :international_rates, :dependent => :destroy
  has_many :minimum_charge_ratings, :dependent => :destroy
  has_many :temp_calls, :dependent => :destroy
  has_many :bills, :dependent => :destroy
  has_many :billed_adjustments, :dependent => :destroy
  has_many :billed_calls, :dependent => :destroy
  has_many :billed_lines, :dependent => :destroy
  has_many :billed_services, :dependent => :destroy
  has_many :billed_taxes, :dependent => :destroy
  has_many :billing_sessions, :dependent => :destroy
  
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :logo2, :if => :logo2_x_position? and :logo2_y_position?
  validates_presence_of :logo2_x_position, :if => :logo2?
  validates_presence_of :logo2_y_position, :if => :logo2?
  validates_presence_of :decimals
  validates :decimals, :numericality => {:greater_than => 0, :less_than_or_equal_to => 4}
  
  def logo_file=(input_data) 
    self.logo_filename = input_data.original_filename 
    self.logo_type = input_data.content_type.chomp
    self.logo = input_data.read 
  end
  def logo2_file=(input_data) 
    self.logo2_filename = input_data.original_filename 
    self.logo2_type = input_data.content_type.chomp
    self.logo2 = input_data.read
  end
end
