require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:tutor) { FactoryGirl.create(:tutor) }
  
  let(:token) do
    tutor
    post user_session_path, params: {"user": { "email": tutor.email, "password": "password"}}
    token = ActiveSupport::JSON.decode(response.body)["token"]
  end

  5.times do |i|
    let("project#{i}") { FactoryGirl.create(:project) }
  end 

  describe "프로젝트 조회" do
    describe "프로젝트 전체 조회" do
      it "전체 조회 성공" do
        get projects_path, headers: { "Authorization": token}
        expect(response).to have_http_status(200)
      end
    end

    describe "튜터의 프로젝트 조회" do 
      it "정상적인 조회" do 
        get projects_path, params: { q: {tutor_id_eq: tutor.id }}, headers: { "Authorization": token }
        expect(response).to have_http_status(200)
      end

      it "없는 튜터 id" do
        get projects_path, params: { q: {tutor_id_eq: 50 }}, headers: { "Authorization": token }
        expect(response).to have_http_status(400)
      end
      # it "해당 튜터가 만든 프로젝트가 없을 경우" do
      #   get projects_path, params: { q: {tutor_id_eq: tutor.id }}, headers: { "Authorization": token }
      #   expect(response).to have_http_status(200)
      # end
    end

    describe "특정 프로젝트 검색" do
      it "정상적인 프로젝트 검색 요청" do
        get projects_path, params: { q: { title_or_description_i_cont: project1.title[0..2] }}, headers: { "Authorization": token }
        expect(response).to have_http_status(200)
      end
    end
  end
 
  describe "프로젝트 생성" do
		context "정상" do
			it "정상 일 때" do
				post projects_path, params: { "project": {tutor_id: tutor.id, experience_period: 14, description: "설명", deposit: rand(10000..99999), title: "프로젝트 #{rand(1..9)}" } }, headers: {"Authorization": token}
				expect(response).to have_http_status(200)
			end
		end
		
		context "비정상" do
			it "제목 누락" do
        post projects_path, params: { "project": {tutor_id: tutor.id, experience_period: 14, description: "설명", deposit: rand(10000..99999)} }, headers: {"Authorization": token}
				expect(response).to have_http_status(400)
			end
		end

	end
end
