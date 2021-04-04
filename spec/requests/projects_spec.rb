require 'rails_helper'

RSpec.describe "Projects", type: :request do
  # describe "GET /index" do
  #   pending "add some examples (or delete) #{__FILE__}"
  # end
	before do
		Project.create(tutor_id: User.ids.shuffle.first, experience_period: Datetime.now, description: "설명", deposit: rand(10_000..99_999), title: "프로젝트 #{rand(1..9)}")
	end
	
	# null:false, 튜터아이디, 제목
	describe "프로젝트 생성" do
		
		context "정상" do
			it "정상 일 때" do
				post projects_path, params: { "project": {tutor_id: Tutor.ids.shuffle.first, experience_period: Datetime.now, description: "설명", deposit: rand(10000..99999), title: "프로젝트 #{rand(1..9)}" } }
				expect(response).to have_http_status(200)
			end
		end
		
		context "비정상" do
			xit "제목 누락" do
				
			end
		
			xit "튜터 누락" do
		
			end
		end

	end
end
