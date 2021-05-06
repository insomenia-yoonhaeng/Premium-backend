class Tutor < User
	include Authable
<<<<<<< HEAD
	#has_one :auth, as: :authable, class_name: 'Auth', dependent: :destroy # 튜터일 경우는 인증 객체는 하나, 이미지는 다수
    
	has_many :projects, dependent: :nullify
=======

	has_many :projects, dependent: :destroy
	has_many :attendances, through: :projects

	has_many :options
	has_many :chapters, through: :options
>>>>>>> 7044e9bd4ba341e8111b857cef255418ee72c099
end
