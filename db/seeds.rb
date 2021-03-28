# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

def generate_user
  ["Tutor","Tutee"].each do |object|
    5.times do |i|
      object.constantize.create(
        email: "#{object}#{i+1}@test.com", 
        password: "password", 
        name: "#{Faker::Name::name.gsub(/\s+/, "")}", 
        phone: "010-"+ rand(1000..9999).to_s + "-" + rand(1000...9999).to_s,
        image: File.open("public/image/seedImage/seed#{rand(1..10)}.jpg"),
        status: (object == "Tutor") ? "approving" : "default")
      puts "#{object}#{i+1} 생성완료!"
    end
  end
end

User.destroy_all
generate_user