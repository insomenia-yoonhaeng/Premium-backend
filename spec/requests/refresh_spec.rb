require 'rails_helper'

RSpec.describe "Refreshes", type: :request do
  
  before do
    Tutor.create(email: "testuser@test.com", password: "password", name: "홍길동", phone: "010-1234-5678")
    post user_session_path, params: {"user": { "email": "testuser@test.com", "password": "password"}}
    puts response
  end

  context "토큰 refresh" do
    xit "유효한 토큰으로 리프레쉬 요청" do
      @current_user = @tutor
      post auth_path, params: { "auth": {  }}
      expect(response).to have_http_status(200)
    end
  end
end
