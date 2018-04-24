class ProjectController < ApplicationController
    before_action :authenticate_user!
    def index
        @projects = current_user.projects.order(:created_at).reverse
    end
    def new
    
    end
    
    def show
        @project = Project.find(params[:id])
        @releaselogs = @project.releaselogs.order(:created_at).reverse
    end
    
    def create
        @project = current_user.projects.new(project_params)
        @project.webhook = generate_webhook
        @project.secret = SecureRandom.hex(13)
        @project.save
        redirect_to @project
    end
    def settings
        @project = current_user.projects.find(params[:id])
    end

    private
    def project_params
        params.require(:project).permit(:name)
    end
    def generate_webhook
        loop do
          webhook = SecureRandom.hex(13)
          break webhook unless Project.where(webhook: webhook).exists?
        end
      end
end
