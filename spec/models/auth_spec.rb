require 'rails_helper'

RSpec.describe Auth, type: :model do
  before do 
    @tutor = FactoryGirl.create(:tutor)
    @tutee = FactoryGirl.create(:tutee)
    @user = FactoryGirl.create(:user)
    @images = []
    @images << File.open("public/image/seedImage/seed#{rand(1..10)}.jpg")
  end

  context "인증 모델 생성" do
    xit "이미지 여러개 인증 생성" do
      
    end
  end

end
