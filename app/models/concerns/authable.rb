module Authable
  extend ActiveSupport::Concern
  included do
    has_many :auths, as: :authable, class_name: 'Auth', dependent: :destroy # 인증이 많을 수 있다. 학생의 경우 챕터마다 인증
    
		# 인증을 받았는지 확인
    def is_authed? _user
      auths.exists?(user: _user)
    end
  end
end