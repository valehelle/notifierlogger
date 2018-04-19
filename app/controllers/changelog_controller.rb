class ChangelogController < ApplicationController
    skip_before_action :verify_authenticity_token
    def webhook
        
        render status: :ok
    end

end
