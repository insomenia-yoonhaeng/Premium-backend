require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    User.create(email: "testuser@test.com", password: "password", name: "홍길동", phone: "010-1234-5678")
  end

  context "유저 생성 관련" do
    it "잘못된 이메일 입력" do
      user = User.create(email: nil, password: "password", name: Faker::Name::name.gsub(/\s+/, ""))
      expect(user).to validate_presence_of(:email)
    end
    xit "중복 이메일 입력" do
      user = User.create(email: "testuser@test.com", password: "password", name: Faker::Name::name.gsub(/\s+/, ""))
      expect(user).to eq nil
    end
    xit "잘못된 이름 입력" do
      user = User.create(email: nil, password: "password", name: Faker::Name::name.gsub(/\s+/, ""))
      expect(user).to eq nil
    end
  end
end
