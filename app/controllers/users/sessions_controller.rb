# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include JWTSessions::RailsAuthorization

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user, only: [:destroy]
  before_action :authorize_access_request!, only: [:destroy]
  prepend_before_action :require_no_authentication, only: :cancel

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  def create
    super do |user|
      if user.persisted?
        payload = { user_id: user.id}
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
        tokens = session.login
        render json: { csrf: tokens[:csrf], token: tokens[:access], refresh_token: tokens[:refresh], is_omniauth: false, email: user.email, name: user.name, status: user.status, info: user.info, phone: user.phone , type: user.type} and return
      else
        not_found
      end
    end
  end

  def destroy
    super do |user|
      begin
        session = JWTSessions::Session.new(payload: payload)
        session.flush_by_access_payload
        render json: { result: "성공적으로 로그아웃 되었습니다" }, status: :ok and return
      rescue => exception
        puts exception
        render json: { error: "현재 로그인된 유저가 없습니다" }, status: :bad_request and return
      end
    end
  end

  private

  def not_found
    render json: { error: "Cannot find email/password combination"}, status: :not_found
  end

  def not_authorized
    render json: { error: "Not authorized" }, status: :unauthorized
  end

end
