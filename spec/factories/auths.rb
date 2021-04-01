FactoryGirl.define do
  factory :auth do
    authable { FactoryGirl.create(:tutor) }
  end
end
