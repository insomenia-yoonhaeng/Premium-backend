module Imageable
	included do
		has_many :images, as: :imagable, dependent: :destroy
		accepts_nested_attributes_for 
			:images, # 다 수 개의 이미지 
			reject_if: :all_blank, # 등록되는 이미지 없다면, 리젝트 
			allow_destroy: true
	end
end