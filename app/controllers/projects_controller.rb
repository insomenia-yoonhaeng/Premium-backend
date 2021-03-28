class ProjectsController < ApiController
	before_action :authorize_request
	before_action :check_user_type, except: %i(index show)
  before_action :load_project, except: %i(index create)
	
	def index
		projects = Project.all
		render json: each_serializer(projects, ProjectSerializer)
	end

	def create
		begin
			@project = @current_user.projects.create(project_whitelist) 
			render json: serializer(@project, ProjectSerializer) 
		rescue => exception
			render json: {error: @project&.errors&.full_messages&.first}, status: :bad_request
		end
	end
	
	# 일단은 처음이라 튜터도 플젝 여러개, 튜티도 플젝 여러개이므로
	def show
		begin
			render json: serializer(@project, ProjectSerializer)
		rescue => exception
			render json: {error: @project.errors&.full_messages&.first}, status: :bad_request
		end
	end

	def update
		begin
			@project.update(project_whitelist)
			render json: serializer(@project, ProjectSerializer)
		rescue => exception
			render json: {error: @project&.errors&.full_messages&.first}, status: :bad_request			
		end
	end

	def destroy
		begin
			@project.destroy
			render json: { status: :ok }
		rescue => exception
			render json: {error: @project&.errors&.full_messages&.first}, status: :bad_request			
		end
	end
	
	protected

	def load_project
		@project = @current_user.projects.find(params[:id]) if @current_user.project.present?
	end

	def project_whitelist
	 params.require(:project).permit(Project::PERMIT_COLUMNS)
	end

	def check_user_type
	 return unless @current_user.is_a? Tutor
	end

end

