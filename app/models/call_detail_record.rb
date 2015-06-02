class CallDetailRecord < ActiveRecord::Base
	acts_as_tenant(:site)
	mount_uploader :cdr, FileUploader
  	attr_accessible :name, :provider_id, :site_id, :storage_path
  	belongs_to :site
  	belongs_to :provider
  	has_and_belongs_to_many :billing_sessions
  	validates_presence_of :name, :provider_id
  	validates_uniqueness_to_tenant :name
end
