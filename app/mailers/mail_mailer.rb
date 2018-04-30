class MailMailer < ApplicationMailer
    default from: "changelogreminder@gmail.com"
    def sample_email()
        mail(to: "hazmiirfan92@gmail.com", subject: 'Sample Email', body: 'new email')
      end    
end
