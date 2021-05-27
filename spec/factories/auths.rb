FactoryGirl.define do
  factory :auth do
    trait :tutor_auth do
      authable { FactoryGirl.create(:tutor) }
    end

    trait :attendance_auth do
      authable { FactoryGirl.create(:attendance) }
    end
  end

  factory :tutor_auth, class: Auth, traits: [:tutor_auth]
  factory :attendance_auth, class: Auth, traits: [:attendance_auth]
end
