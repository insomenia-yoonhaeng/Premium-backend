FactoryGirl.define do
  factory :attendance do
    tutee { FactoryGirl.create(:tutee) }
    project { FactoryGirl.create(:project) }
    amount { 10000 }
  end
end
