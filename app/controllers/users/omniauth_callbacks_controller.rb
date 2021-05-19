class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def kakao
    auth_login("kakao")
  end

  def apple
    auth_login("apple")
  end

  def after_sign_in_path_for(resource)
    auth = request.env['omniauth.auth']
    @identity = Identity.find_for_oauth(auth)
    if @current_user.persisted?
      root_path
    else
      new_user_registration_path
    end
  end

  private
  ## TODO SIGN_IN & SIGN_UP 
  ## 회원 검증 끝났을 때 oauth에서 보통 어떤식으로 진행...? 회원 가입 시 바로 로그인까지? or 회원 가입 후 로그인 다시 진행?
  def auth_login(provider)
    sns_login = SnsLogin.new(request.env["omniauth.auth"], @current_user) # 서비스 레이어로 작업했습니다.
    @user = sns_login.find_user_oauth
    begin
      if @user.persisted?
        if @user.sign_in_count == 0 # sns로 첫 가입 시 별도 처리하기 위해서 추가했습니다.
          # 회원 가입 진행
          payload = { user_id: @user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          
          response.set_cookie(
            JWTSessions.access_cookie,
            value: tokens[:access],
            httponly: true,
            secure: Rails.env.production?,
          )

          render json: { csrf: tokens[:csrf], token: tokens[:access], refresh_token: tokens[:refresh] ,is_omniauth: true } and return
        else
          # 로그인 진행
          payload = { user_id: @user.id}
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          render json: { csrf: tokens[:csrf], token: tokens[:access], refresh_token: tokens[:refresh] ,is_omniauth: true } and return
        end
      else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"]
        # redirect_to new_user_registration_url, notice: '로그인 에러가 발생하였습니다.'
        render json: {errors: "로그인 에러가 발생했습니다"}, status: :not_found
      end
    rescue 
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      render json: {errors: "로그인 에러가 발생했습니다"}, status: :not_found
    end

  end
end