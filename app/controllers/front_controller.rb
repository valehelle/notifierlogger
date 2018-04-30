class FrontController < ApplicationController
    def index
        MailMailer.sample_email().deliver
    end
end
