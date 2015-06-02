# desc "Batch Emailing"
# task :batch_emailing => :environment do
#   begin
#     billing_session = BillingSession.find(ENV["BILLING_SESSION_ID"], :include => [:site, :bills, {:bills => :account}])
#     ActsAsTenant.with_tenant(billing_session.site) do
#       #Email every bill within the billing session
#       billing_session.bills.each do |bill|
#         if not bill.account.billing_email.nil? and not billing_session.site.from_email.nil?
#           if bill.account.billing_email.length > 0  and billing_session.site.from_email.length > 0
#             if not bill.pdf.length > Source::Application.config.email_attachment_max_size
#               BillMailer.invoice_email(bill.account.billing_email, bill, billing_session.site).deliver
#               bill.emailed = true
#               bill.save
#               bill = nil
#             end
#           end
#         end
#       end
#     end
#   rescue => e
#     Rails.logger.error "ERROR: problem while executing batch_emailing rake task: " + e.message
#     Rails.logger.error e.backtrace.join("\n")
#   ensure
#     billing_session.batch_email_status = BillingSession::EMAILS_SENT
#     billing_session.save
#     billing_session = nil
#   end
# end