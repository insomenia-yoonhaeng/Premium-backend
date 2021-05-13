require 'rails_helper'

RSpec.describe "Auths", type: :request do
  before do 
    @tutor = FactoryGirl.create(:tutor)
    @tutee = FactoryGirl.create(:tutee)
    @user = FactoryGirl.create(:user)
    @image = File.open("public/image/seedImage/seed#{rand(1..10)}.jpg")
  end

  context "인증 생성 관련" do
    xit "튜터 회원가입 시 인증 이미지 생성" do
      @current_user = @tutor
      post auth_path, params: { "auth": {  }}
      expect(response).to have_http_status(200)
    end
    
    xit "튜터가 아닌 튜티가 인증 이미지 생성할 경우" do
    end

    xit "튜터 인증 이미지가 이미 있는데 생성하려고 할 경우" do
    end

  end
end
