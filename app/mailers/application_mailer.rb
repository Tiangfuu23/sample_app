class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.email_from_address
  layout Settings.mailer.mailer_layout
end
