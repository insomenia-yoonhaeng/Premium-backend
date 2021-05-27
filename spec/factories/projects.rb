FactoryGirl.define do
  factory :project do
    tutor_id { FactoryGirl.create(:tutor).id }
    description { "project code name project 1000" } 
    deposit { 15000 }
    title { "project 1000" }
    started_at { DateTime.now }
    duration { 60 }
    experience_period { 14 }
    category_id { FactoryGirl.create(:category).id }
  end
end
