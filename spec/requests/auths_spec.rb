require 'rails_helper'

RSpec.describe "Auths", type: :request do
  
  let(:tutor) { FactoryGirl.create(:tutor) }
  let(:tutee) { FactoryGirl.create(:tutee) }
  let(:image) { File.open("public/image/seedImage/seed#{rand(1..10)}.jpg") }

  let(:token) do
    tutor
    post user_session_path, params: {"user": { "email": tutor.email, "password": "password"}}
    token = ActiveSupport::JSON.decode(response.body)["token"]
  end

  let(:tutee_token) do
    tutee
    post user_session_path, params: {"user": { "email": tutee.email, "password": "password"}}
    token = ActiveSupport::JSON.decode(response.body)["token"]
  end

  context "인증 생성 관련" do
    it "튜터 회원가입 시 인증 이미지 생성" do
      post auths_path, params: { "auth": { "images_attributes": { "0": image } }}, headers: {"Authorization": token}
      expect(response).to have_http_status(200)
    end
    
    it "튜터가 아닌 튜티가 인증 이미지 생성할 경우" do
      post auths_path, params: { "auth": { "images_attributes": { "0": image } }}, headers: {"Authorization": tutee_token}
      expect(response).to have_http_status(400)
    end

    it "튜터 인증 이미지가 이미 있는데 생성하려고 할 경우" do

      auth = tutor.auths.create
      auth.images.create(image: image)
      post auths_path, params: { "auth": { "images_attributes": { "0": image } }}, headers: {"Authorization": token}
      expect(response).to have_http_status(400)
    end

  end
end
