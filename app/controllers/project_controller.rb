class ProjectController < ApplicationController
    before_action :authenticate_user!
    def index
        @projects = current_user.projects
    end
    def new
    
    end
    
    def show
        @project = Project.find(params[:id])
    end
    
    def create
        @project = current_user.projects.new(project_params)
        @project.webhook = 'sdlfjksdaf'
        @project.secret = 'sdfsdfdsf'
        @project.save
        redirect_to @project
    end

    private
    def project_params
        params.require(:project).permit(:name)
    end
end
