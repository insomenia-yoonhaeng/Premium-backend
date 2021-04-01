class Tutor < User
	include Authable
	#has_one :auth, as: :authable, class_name: 'Auth', dependent: :destroy # 튜터일 경우는 인증 객체는 하나, 이미지는 다수
    
	has_many :projects, dependent: :nullify
end
