# app/services/sns_login.rb
class SnsLogin
  attr_reader :auth, :signed_in_resource

  def initialize(auth, signed_in_resource = nil, only_params)
    @auth = auth
    @signed_in_resource = signed_in_resource
    @only_params = only_params
  end

  def find_user_oauth
    identity = build_identity
    user = @signed_in_resource ? @signed_in_resource : identity.user
    if user.nil?
      user = User.create!(get_auth_params)
    end
    update_identity_user(identity, user)
    user
  end

  private
  # 사용자의 Identity 객체 찾기
  def build_identity
    Identity.find_for_oauth(@auth, @only_params)
  end

  # email 날라오는 것 분기처리해서 데이터 해시 만들어주기
  def get_auth_params
    auth_name = @only_params ? "#{@auth.dig("fullName", "familyName")}#{@auth.dig("fullName", "givenName")}" : @auth.info.name
    auth_provider = @only_params ? "Apple" : @auth.provider
    auth_params = {
      password: Devise.friendly_token[0,20],
      name: auth_name,
      account_type: auth_provider
    }
    auth_email = @only_params ? @auth.dig("email") : ""
    if @only_params 
      auth_params[:email] = auth_email
    elsif @auth&.info&.email.present?
      auth_params[:email] = @auth.info.email
    else
      loop do
        @generated_email = "#{auth_provider}#{Time.current.to_i}@ddasup.com"
        break unless User.find_by(email: @generated_email).present?
      end
      auth_params[:email] = @generated_email
    end
    auth_params
  end

  # identity 객체에 사용자정보 업데이트
  def update_identity_user(identity, user)
    if identity.user != user #identity의 유저와 현재 유저를 일치시킵니다.
      identity.user = user
      identity.save
    end
  end
end
