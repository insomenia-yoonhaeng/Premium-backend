class RefreshController < ApiController
  before_action :authorize_refresh_by_access_request!

  ## refresh 에서 401 던지면 로그아웃 필요
  def create
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens  = session.refresh_by_access_payload
    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)

    render json: { csrf: tokens[:csrf], token: tokens[:access] }
  end
end