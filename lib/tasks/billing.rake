# TODO: create an admin view of the billing session queue
# desc "Run billing"
# task :run_billing => :environment do
#   begin
#     billing_session = BillingSession.find(ENV["BILLING_SESSION_ID"])
#     i=0
#     wait = true
#     while wait == true and i < Source::Application.config.minutes_to_wait_in_queue do
#       Rails.logger.info "BILLING_LOG: Waiting for turn in queue for billing session id: " + billing_session.id.to_s + ". Attempt #: " + i.to_s
#       processing_billing_sessions = BillingSession.count(:conditions => {:processing_flag => true})
#       pending_bills = Bill.count(:conditions => {:pending_flag => true})
#       #tested. this is multitenant friendly
#       first_in_queue = BillingSession.find(:first, :select => :id, :conditions => {:pending_flag => true, :processing_flag => false}, :order => 'created_at ASC')
#       #make sure that there is only one session being processed at once and that it is its turn in the queue
#       if (processing_billing_sessions > 0 or pending_bills > 0) || (first_in_queue.id != billing_session.id)
#         sleep 60
#         i = i + 1
#       else
#         wait = false
#         begin
#           ActsAsTenant.with_tenant(billing_session.site) do
#             Rails.logger.info "BILLING_LOG: Calling `do_billing` from `run_billing` rake for: " +  ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
#             do_billing(billing_session)
#           end
#         rescue => e1
#           #set to 'failed' and leave the loop
#           if not billing_session.nil?
#             #this will trigger a 'save'
#             billing_session.failed = true
#           end
#         end
#       end
#     end
#     if not billing_session.nil?
#       if billing_session.pending_flag == true or billing_session.processing_flag == true or billing_session.failed == true #do this just in case the process died at some point
#         billing_session.pending_flag = false
#         billing_session.processing_flag = false
#         billing_session.failed = true
#         billing_session.save
#       end
#     end
#     billing_session = nil
#     processing_billing_sessions = nil
#     pending_bills = nil
#     first_in_queue = nil
#     wait = nil
#     i = nil
#   rescue => e2
#     Rails.logger.error "ERROR: problem while executing run_billing rake task: " + e2.message
#     Rails.logger.error e2.backtrace.join("\n")
#     #set the billing session to 'failed'
#     if not billing_session.nil?
#       billing_session.pending_flag = false
#       billing_session.processing_flag = false
#       billing_session.failed = true
#       billing_session.save
#     end
#   end
# end

# TODO: create an admin view of the bill queue
# desc "Re-generate bill"
# task :regenerate_bill => :environment do
#   begin
#   bill = nil
#   i = 0
#   wait = true
#   while wait == true and i < Source::Application.config.minutes_to_wait_in_queue do
#     processing_billing_sessions = BillingSession.count(:conditions => {:processing_flag => true})
#     # Make sure there is no processing billing sessions.
#     # Regenerating a bill shouldn't take long ... 
#     # ... so it is OK (for now) to have more than one bill regenerating at the same time
#     if processing_billing_sessions > 0
#       sleep 60
#       i = i + 1
#     else
#       wait = false
#       bill = Bill.find(ENV["BILL_ID"])
#       begin
#         ActsAsTenant.with_tenant(bill.site) do
#           generate_bill_files(bill)
#         end
#       rescue => e1
#         Rails.logger.error "ERROR: problem while executing generate_bill_files: " + e1.message
#         Rails.logger.error e1.backtrace.join("\n")
#       end
#     end
#   end
#   if not bill.nil?
#     if bill.pending_flag == true #do this just in case the process died at some point
#       bill.pending_flag = false
#       bill.save
#     end
#   end
#   bill = nil
#   pending_billing_sessions = nil
#   pending_bills = nil
#   wait = nil
#   i = nil
#   rescue => e2
#     Rails.logger.error "ERROR: problem while executing regenerate_bill rake task: " + e2.message
#     Rails.logger.error e2.backtrace.join("\n")
#   end
# end