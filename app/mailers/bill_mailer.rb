class BillMailer < ActionMailer::Base
  def invoice_email(recipient, bill, site)
    @site = site
    email_with_name = "#{site.name} <info+#{site.name.titleize.gsub(/[^0-9a-z]/i, '')}@easytelecombilling.com>"
    attachments[bill.pdf.file.filename] = {:mime_type => 'application/pdf', :content => bill.pdf.read }
    Rails.logger.info "EMAIL: sending email to " + recipient.to_s
    mail(:from => email_with_name, :reply_to => site.from_email, :to => recipient, :subject => "Your Invoice from " + site.name)
  end
end
