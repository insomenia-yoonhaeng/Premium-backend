# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include JWTSessions::RailsAuthorization

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user, only: [:destroy]
  before_action :authorize_access_request!, only: [:destroy]
  prepend_before_action :require_no_authentication, only: :cancel

  def create
    super do |user|
      if user.persisted?
        payload = { user_id: user.id}
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
        tokens = session.login
        render json: { csrf: tokens[:csrf], token: tokens[:access], is_omniauth: false, email: user.email, name: user.name, status: user.status, info: user.info, phone: user.phone } and return
      else
        not_found
      end
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: { result: "성공적으로 로그아웃 되었습니다" }, status: :ok and return
  end

  private

  def not_found
    render json: { error: "Cannot find email/password combination"}, status: :not_found
  end
end
