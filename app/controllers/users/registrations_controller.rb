class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :exception
  skip_before_action :authenticate_scope!, only: [:update]
  skip_before_action :verify_authenticity_token
  prepend_before_action :require_no_authentication, only: :cancel
  
  def create
    begin
      super do |user|
        if user.persisted?
          if resource.active_for_authentication?          
            payload = { user_id: user.id }
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = session.login

            response.set_cookie(
              JWTSessions.access_cookie,
              value: tokens[:access],
              httponly: true,
              secure: Rails.env.production?,
            )
  
            render json: { csrf: tokens[:csrf], token: tokens[:access], refresh_token: tokens[:refresh] ,is_omniauth: false } and return
          else
            render json: { error: I18n.t("devise.registrations.signed_up_but_inactive") }, status: :locked and return
          end
        else
          render json: { error: user.errors.full_messages.join(' ') }, status: :bad_request and return
        end
      end
    rescue ActiveRecord::NotNullViolation => exception
      puts exception
      Rails.logger.info exception
      render json: { error: "유저 정보에는 이름, 이메일, 패스워드가 포함되어 있어야 합니다" }, status: :not_found and return
    end
  end
end