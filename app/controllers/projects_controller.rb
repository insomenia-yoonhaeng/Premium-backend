class ProjectsController < ApiController
	# before_action :current_api_user
  before_action :authorize_check_request
	before_action :check_user_type, except: %i(index show)
  before_action :load_project, except: %i(index create)
	
	def index
		begin
			Rails.logger.info "Article Information: #{params[:q]}" if params[:q].present?
			projects = Project.ransack(params[:q])&.result
			render json: each_serializer(projects, ProjectSerializer)
		rescue => exception
			render json: { error: projects&.errors&.full_messages&.first }, status: :bad_request
		end
	end

	def create
		begin
			project = @current_user.projects.create(project_params)
			render json: serializer(project, ProjectSerializer) 
		rescue => exception
			render json: {error: project&.errors&.full_messages&.first}, status: :bad_request
		end
	end
	
	def show
		# show는 자신의 프로젝트가 아니더라도 접근 가능해야하므로 load_proejct로 참조해오는 것은 적합하지 않음, 체험기간에도 볼 수 있어야하므로
		begin
			proejct = Proejct.find(params[:id])
			render json: serializer(project, ProjectSerializer)
		rescue => exception
			render json: {error: project.errors&.full_messages&.first}, status: :bad_request
		end
	end

	def update
		begin
			project.update(project_params)
			render json: serializer(project, ProjectSerializer)
		rescue => exception
			render json: {error: project&.errors&.full_messages&.first}, status: :bad_request			
		end
	end

	def destroy
		begin
			project.destroy
			render json: { status: :ok }
		rescue => exception
			render json: {error: project&.errors&.full_messages&.first}, status: :bad_request			
		end
	end
	
	protected

	def load_project
		project = @current_user.projects.find(params[:id]) if @current_user.projects.present?
	end

	def project_params
		params.require(:project).permit(Project::PERMIT_COLUMNS)
	end

end

