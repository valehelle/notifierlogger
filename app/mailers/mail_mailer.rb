class MailMailer < ApplicationMailer
    default from: "changelogreminder@gmail.com"
    def send_notification(user,name,version_released)
        mail(to: user, subject: 'Changelog notification', body: 'New version of ' + name + ' (' + version_released + ') has been released')
      end    
end
