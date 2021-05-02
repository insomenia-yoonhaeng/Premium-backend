# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.destroy_all
p "어드민 삭제"
AdminUser.create!(email: 'admin@ddasoop.com', password: 'password', password_confirmation: 'password') 
p "어드민 유저 생성"

def generate_user
  %w(Tutor Tutee).each do |object|
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

def generate_project
  5.times.each do |i|
    Project.create(
      tutor_id: Tutor.ids.shuffle.first,
      description: "project code name project_#{i}",
      deposit: 15000,
      image: File.open("public/image/seedImage/seed#{rand(1..10)}.jpg"),
      title: "project #{i}",
      started_at: DateTime.now,
      duration: 60,
      experience_period: 14,
      category_id: Category.ids.shuffle.first
    )
  end
end

def generate_category
  %w(국어 수학 영어 과학탐구 사회탐구 기타).each do |title|
    Category.create(title: title)
  end
end

def generate_attendance
  Tutee.all.each{ |tutee| tutee.attendances.create(project_id: Project.all.sample.id) }
end

#User.destroy_all
#generate_user
#Project.destroy_all
#generate_projects

def generate_seed
  puts "생성시킬 모델을 입력해주세요(끝내려면 done를 입력해주세요)"
  keyword = '', models = Array.new
  while true
    begin
      input = STDIN.gets.chomp
      break if input == 'done'
      input.classify.constantize
    rescue Exception
      puts "존재하지 않는 모델입니다."
    else
      models << input.classify
    end
  end
  User.destroy_all
  puts "유저 삭제 완료"
  generate_user
  models.each do |model|
    model.constantize.send("destroy_all")
    send("generate_#{model.downcase}")
    puts "#{model} seed 생성 완료"
  end
end

generate_seed