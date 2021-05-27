class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def kakao
    # webview식 구현
    auth_login("kakao", false)
  end

  def apple
    auth_login("apple", true)
    # 모듈 써서 구현된 것은 정보만 받아서 생성 후 적용
  end

  private
  ## TODO SIGN_IN & SIGN_UP 
  ## 회원 검증 끝났을 때 oauth에서 보통 어떤식으로 진행...? 회원 가입 시 바로 로그인까지? or 회원 가입 후 로그인 다시 진행?
  def auth_login(provider, only_params)
    auth_hash = only_params ? params : request.env["omniauth.auth"]
    sns_login = SnsLogin.new(auth_hash, @current_user, only_params) 
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

          render json: { csrf: tokens[:csrf], token: tokens[:access], refresh_token: tokens[:refresh] ,is_omniauth: true , user_id: @user.id} and return
        else
          # 로그인 진행
          payload = { user_id: @user.id}
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          render json: { csrf: tokens[:csrf], token: tokens[:access], refresh_token: tokens[:refresh] ,is_omniauth: true } and return
        end
      else
        session["devise.#{provider}_data"] = auth_hash
        # redirect_to new_user_registration_url, notice: '로그인 에러가 발생하였습니다.'
        render json: {errors: "로그인 에러가 발생했습니다"}, status: :not_found
      end
    rescue 
      session["devise.#{provider}_data"] = auth_hash
      render json: {errors: "로그인 에러가 발생했습니다"}, status: :not_found
    end

  end
end