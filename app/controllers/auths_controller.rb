class AuthsController < ApiController
  # before_action :current_api_user
  before_action :authorize_check_request
  before_action :check_user_type, only: %i(update)
  before_action :load_auth, only: %i(update show)
  before_action :load_project, only: %i(create update)
  # TODO auth controller 도 target으로 생성 하도록 (attendance & tutor)
  
  def index
    begin
      @auths = @current_user&.auths
      render json: each_serializer(@auths, AuthSerializer), status: :ok
    rescue => exception
      puts exception
      render json: { errors: "에러 발생!" }, status: :not_found      
    end
  end

  def create
    begin
      target = (@current_user.is_a? Tutor) ? @current_user : @current_user&.attendances.where(project_id: @project.id)&.first
      @auth = target&.auths.create(auth_params) unless check_auth # auth모델이 생성되면 안되는 경우를 제외
      @current_user.approving! if @auth.present? && (@current_user.is_a? Tutor)
      render json: serializer(@auth, AuthSerializer), status: :ok
    rescue => exception
      render json: {errors: @auth&.errors&.full_messages&.first}, status: :bad_request
    end
  end

  def update
    begin
      target = (@current_user.is_a? Tutor) ? @current_user : @current_user&.attendances.where(project_id: @project.id)&.first
      @auth = target.auths.find_by(id: params[:id])
      @auth.update auth_params unless check_auth
      render json: serializer(@auth, AuthSerailizer), status: :ok
    rescue => exception
      render json: {errors: @auth&.errors&.full_messages&.first}, status: :bad_request
    end
  end

  def show_all
    begin
      if @current_user.is_a? Tutor
        project = @current_user.projects.find(params[:project_id]) 
        render json: each_serializer(project.auths, AuthSerializer), status: :ok
      else
        render json: { errors: "튜터만 접근 가능합니다"}, status: :bad_request
      end
    rescue => exception
      render json: { errors: "없는 프로젝트입니다"}, status: :bad_request
    end
  end

  def destroy;end

  private

  def auth_params
    params.require(:auth).permit(Auth::PERMIT_COLUMNS)
  end
  
  def load_auth
    begin
      @auth = target.auths.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {errors: 'Authentication not found'}, status: :not_found
    end
  end

	def load_project
		@project = Project.find(params[:project_id])
	end
end