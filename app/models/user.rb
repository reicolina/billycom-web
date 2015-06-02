class User < ActiveRecord::Base
  #acts_as_tenant(:site) Commented out to avoid multitenancy conflicts
  attr_accessible :username, :password, :password_confirmation, :admin, :site_id
  belongs_to :site
  validates_presence_of :username, :password, :site_id
  
  acts_as_authentic do |c|
    c.logged_in_timeout = 10.minutes
  end
  
end
