class AuthenticationController < ApplicationController
	before_action :authenticate_params, only: %w(token_create)
  before_action :authorize_request, only: %i(logout)
  ## JWT 토큰 생성을 위한 Devise 유저 정보 검증
  
  def token_create
		return unless authenticate_params
    ## body로 부터 받은 json 형식의 params를 parsing
      @user = User.find_by(email: authenticate_params[:email])
      if @user&.authenticate(authenticate_params[:password])
        @user_key = "user:#{@user.id}"
        Rails.cache.write(@user_key,true,expires_in: 7.days)
        render json: {token: payload(@user), name: @user.name}, status: :ok
      else 
        render json: {error: 'unauthorized'}, status: :unauthorized
      end
  end

  def logout
    @user_key = "user:#{@current_user.id}"
    valid = Rails.cache.read(@user_key)
    if valid
      Rails.cache.delete(@user_key)
      render json: {message: "성공적으로 로그아웃 되었습니다!"}, status: :ok
    else
      render json: {error: "unauthorized"}, status: :unauthorized
    end
  end 

  private

  ## Response으로서 보여줄 json 내용 생성 및 JWT Token 생성
  def payload(user)
    ## 해당 코드 예제에서 토큰 만료기간은 '30일' 로 설정
    @token = JWT.encode({ user_id: user.id, exp: 30.days.from_now.to_i }, ENV["SECRET_KEY_BASE"])	
    # 보여줄 정보들 (json 형식)
    #@tree = { :"JWT token" => @token, :userInfo => {id: user.id, email: user.email} } 
    
    return @token
  end

	def authenticate_params
		authenticate_params = params.fetch(:user, {}).permit(:email, :password)
	end
  
end