require 'rails_helper'

RSpec.describe "Refreshes", type: :request do
  let(:user) { Tutor.create(email: "testuser@test.com", password: "password", name: "홍길동", phone: "010-1234-5678") }
  let(:token) do
    user
    post user_session_path, params: {"user": { "email": "testuser@test.com", "password": "password"}}
    token = ActiveSupport::JSON.decode(response.body)["token"]
  end

  context "현재 유저 조회 관련" do 
    it "현재 유저 접근 성공" do
      get get_current_user_path, headers: {"Authorization": token}
      expect(ActiveSupport::JSON.decode(response.body)["email"]).to eq user.email
      expect(ActiveSupport::JSON.decode(response.body)["id"]).to eq user.id
      expect(ActiveSupport::JSON.decode(response.body)["name"]).to eq user.name
      expect(ActiveSupport::JSON.decode(response.body)["phone"]).to eq user.phone
      expect(response).to have_http_status(200)
    end
  end

  context "토큰 refresh" do
    it "유효한 토큰으로 리프레쉬 요청" do
      post refresh_path, headers: {"Authorization": token}
      expect(response).to have_http_status(200)
    end
  end
end
