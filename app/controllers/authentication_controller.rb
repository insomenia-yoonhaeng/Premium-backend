class AuthenticationController < ApiController
	before_action :authenticate_params, only: %w(token_create)
  before_action :authorize_request, only: %i(logout get_current_user)
  ## JWT 토큰 생성을 위한 Devise 유저 정보 검증
  
  def login
		return unless authenticate_params
    ## body로 부터 받은 json 형식의 params를 parsing
    @user = User.find_by(email: authenticate_params[:email])
		if @user&.authenticate(authenticate_params[:password])
			Rails.cache.write 'current_user', @user, expires_in: 7.hour
			render json: {token: create_token(@user), name: @user.name}, status: :ok
		else 
			render json: {error: 'unauthorized'}, status: :unauthorized
		end
  end

  def logout
    if Rails.cache.read 'current_user'
      Rails.cache.delete 'current_user'
      render json: {message: "성공적으로 로그아웃 되었습니다!"}, status: :ok
    else
      render json: {error: "unauthorized"}, status: :unauthorized
    end
  end 

  def get_current_user
    begin
      @current_user
      render json: serializer(@current_user, UserSerializer, [:id, :name, :type]), status: :ok
    rescue => exception
      render json: {errors: @current_user&.errors&.full_messages&.first}, status: :bad_request
    end
  end

  private

  ## Response으로서 보여줄 json 내용 생성 및 JWT Token 생성
  def create_token user
    ## 해당 코드 예제에서 토큰 만료기간은 '30일' 로 설정
    @token = JWT.encode({ user_id: user.id, exp: 30.days.from_now.to_i }, ENV["SECRET_KEY_BASE"])	
    # 보여줄 정보들 (json 형식)
    #@tree = { :"JWT token" => @token, :userInfo => {id: user.id, email: user.email} } 
    return @token
  end

	def authenticate_params
		authenticate_params = params.fetch(:user, {}).permit(User::PERMIT_COLUMNS)
	end
  
end