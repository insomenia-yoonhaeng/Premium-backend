class Project < ApplicationRecord
	include ImageUrl
	include Imageable
	acts_as_paranoid
	
	PERMIT_COLUMNS = [:experience_period, :description, :deposit, :image, :title, :category_id, :book_id, :duration, :started_at]
	
  belongs_to :tutor, optional: true
	has_many :attendances, dependent: :nullify
	belongs_to :category, optional: true
	belongs_to :book, optional: true

	# chapter 1 : N option
	# 같은 챕터를 사용하는 서로 다른 튜터가 매긴 옵션
	def make_schedule
		weight_sum = 0
		# 가중치 합 구하기
		
		self.tutor.options.destroy_all if self.tutor.options.present?
		
		self.book.chapters.each do | chapter |
			weight_sum += chapter.options.find_by(tutor: self.tutor).weight
		end

		
		# 챕터 시작, 끝 날짜 계산하기
		start_date = DateTime.now, end_date = DateTime.now
		# DateTime.on_weekend? => 주말인지 아닌지 true : false
		self.book.chapters.each_with_index do | chapter, index |
			# puts self.started_at
			start_date = index != 0 ? end_date + 1.days : self.started_at # 첫 인덱스면, 첫 챕터니까 이 챕터의 시작일은 프로젝트의 시작일과 같다. 정렬 순서 뒤바꾸지 않는 이상 괜찮다 created_at
			option = chapter.options.find_by(tutor: self.tutor) # chpater의 option들 중에 해당 프로젝트의 튜터가 만든 것을 찾는다.
			end_date = start_date + ((self.duration * ( option.weight.to_f / weight_sum )).to_i - 1).days
			option.update(start_at: start_date, end_at: end_date)
		end
	end
end
