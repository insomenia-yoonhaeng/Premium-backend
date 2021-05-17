# app/services/sns_login.rb
class SnsLogin
  attr_reader :auth, :signed_in_resource

  def initialize(auth, signed_in_resource = nil)
    @auth = auth
    @signed_in_resource = signed_in_resource
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
    Identity.find_for_oauth(@auth)
  end

  # email 날라오는 것 분기처리해서 데이터 해시 만들어주기
  def get_auth_params
    auth_params = {
      name: @auth.info.name,
      password: Devise.friendly_token[0,20],
      name: "#{@auth.info.last_name}#{@auth.info.first_name}",
      account_type: @auth.provider
    }
    if @auth.info.email.present? # 카카오의 경우 email을 받아올 수 없어서 아래와 같이 처리했습니다. 또한 sns 계정 로그인 할 때 이메일 계정이 아닌 경우가 있어서 일반화하여 처리할 수 있습니다.
      auth_params[:email] = @auth.info.email
    else
      loop do
        uniq_num = SecureRandom.hex(3).downcase
        @generated_email = "#{@auth.provider}#{uniq_num}@ddaseup.com"
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
