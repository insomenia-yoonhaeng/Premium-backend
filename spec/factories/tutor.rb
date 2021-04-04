FactoryGirl.define do
  factory :tutor do
    email    { Faker::Internet.email }
    password { "password" }
    name { Faker::Name::name.gsub(/\s+/, "") }
    phone { "010-" + rand(1000..9999).to_s + "-" + rand(1000..9999).to_s }
  end
end