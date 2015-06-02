class Account < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :active, :account_number, :title, :address, :city, :province_or_state, :zip_or_postal_code, :billing_email, :main_contact_name, :main_contact_phone, :main_contact_fax, :main_contact_email, :sales_rep_id
  belongs_to :site
  belongs_to :sales_rep
  has_many :lines, :dependent => :destroy, :order => '`type_of_line`, `use`, `number`'
  has_many :other_services, :dependent => :destroy
  has_many :adjustments, :dependent => :destroy
  has_many :bills, :dependent => :destroy
  has_and_belongs_to_many :taxes
  validates_presence_of :account_number
  validates_uniqueness_to_tenant :account_number
  validates_presence_of :title
  validates_uniqueness_to_tenant :title
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :province_or_state
  validates_presence_of :zip_or_postal_code
  validates_numericality_of :main_contact_phone,:allow_blank => true
  validates_length_of :main_contact_phone,:is => 10,:allow_blank => true
  validates_presence_of :sales_rep_id
  validates_numericality_of :main_contact_fax, :allow_blank =>true
  validates_length_of :main_contact_fax,:is => 10,:allow_blank => true
  validates_format_of :billing_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:allow_blank => true
  validates_format_of :main_contact_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:allow_blank => true
  
  def self.search(search_string)
    if search_string
      find(:all, :conditions => ["title LIKE ? or account_number LIKE ? or lines.number = ?", "%#{search_string}%", "%#{search_string}%", "#{search_string}"], :include => :lines, :order => :title)
    else
      []
    end
  end

end
