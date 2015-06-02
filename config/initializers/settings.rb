# Be sure to restart your server when you modify this file.

# Pagination Settings
Source::Application.config.items_per_page = 100

# Authentication Settings
Source::Application.config.master_user = 'admin'
Source::Application.config.master_hash = '6bfcc4026b5f162799a6dc8305c09db9c1674ac616bd5c7422a45fbb6d0816ac163047c47a1f426f4f4c6b5b5042c671eabc4fdc7310fd5b183eef59dc274604'

# Billing Process Settings
Source::Application.config.minutes_to_wait_in_queue = 60
Source::Application.config.max_amount_of_records_per_bill = 30000

# Mailer Settings
Source::Application.config.email_attachment_max_size = 10000000 # 10MB
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => '',
  :port           => ,
  :domain         => '',
  :authentication => :plain,
  #EasyTelecomBilling
  :user_name      => '',
  :password       => ''
}

#Memory Management Settings
Source::Application.config.gc_start_loop_count=1000