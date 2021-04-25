class AuthsController < ApiController
  before_action :current_api_user
  before_action :authorize_check_request
  before_action :check_user_type, only: %i(create update)
  before_action :load_auth, only: %i(update show)

  def index
    @auths = @current_user.auths
    render json: each_serializer(@auths, AuthSerializer), status: :ok
  end

  def create
    begin
      @auth = @current_user.auths.create auth_params unless check_auth # auth모델이 생성되면 안되는 경우를 제외
      @current_user.approving! if @auth.present?
      render json: serializer(@auth, AuthSerializer), status: :ok
    rescue => exception
      render json: {errors: @auth&.errors&.full_messages&.first}, status: :bad_request
    end
  end

  def update
    begin
      @auth.update auth_params unless check_auth
      render json: serializer(@auth, AuthSerailizer), status: :ok
    rescue => exception
      render json: {errors: @auth&.errors&.full_messages&.first}, status: :bad_request
    end
  end

  def destroy;end

  private
  
  def auth_params
    params.require(:auth).permit(Auth::PERMIT_COLUMNS)
  end
  
  def load_auth
    @auth = @current_user.auths.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {errors: 'Authentication not found'}, status: :not_found
  end
end
