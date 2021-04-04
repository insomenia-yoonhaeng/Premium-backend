require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    Tutor.create(email: "Tutor@test.com", password: "password", name: "김튜터", phone: "010-1234-5678")
    Tutee.create(email: "Tutee@test.com", password: "password", name: "홍학생", phone: "010-4321-5678")
  end
  context "회원 가입 관련" do
    it "정상적인 회원 가입" do
      post users_path, params: { "user": { "email": "Tutor2@test.com", "password": "password", "name": "가나다"}  }
      expect(response).to have_http_status(200)
    end
    it "이메일 중복" do
      post users_path, params: { "user": { "email": "Tutor@test.com", "password": "password", "name": "가나다"}  }
      expect(response).to have_http_status(400)
    end
    it "이메일 없음" do
      post users_path, params: { "user": { "email": nil, "password": "password", "name": "가나다"}  }
      expect(response).to have_http_status(400)
    end
    xit "이름 없음" do
      post users_path, params: { "user": { "email": nil, "password": "password", "name": "가나다"}  }
      expect(response).to have_http_status(400)
    end
    it "비밀번호 없음" do
      post users_path, params: { "user": { "email": "Tutor2@test.com", "name": "가나다"}  }
      expect(response).to have_http_status(200)
    end
  end
end
