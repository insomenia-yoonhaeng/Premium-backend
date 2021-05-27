FactoryGirl.define do
  factory :image do
    trait :user_avatar do
      image { File.open("public/image/seedImage/seed#{rand(1..10)}.jpg") }
      imageable { FactoryGirl.create(:tutor) }
    end

    trait :auth_image do
      image { File.open("public/image/seedImage/seed#{rand(1..10)}.jpg") }
      imageable { FactoryGirl.create(:auth) }
    end

    trait :normal_image do
      image { File.open("public/image/seedImage/seed#{rand(1..10)}.jpg") }
    end

    factory :user_image, class: Image, traits: [:user_avatar]
    factory :auth_image, class: Image, traits: [:auth_image]
    factory :default_image, class: Image, traits: [:normal_image]
  end
end
