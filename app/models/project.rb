class Project < ApplicationRecord
	
	include ImageUrl
	include Imageable
	acts_as_paranoid
	
	PERMIT_COLUMNS = [:description, :deposit, :image, :title, :started_at, :duration, :experience_period, :category_id, :required_time, :review_weight, :mission, :book_id, :rest]
	
  belongs_to :tutor, optional: true
	has_many :attendances, dependent: :nullify
	belongs_to :category, optional: true
	belongs_to :book, optional: true

	enum rest: %i(allow disallow)

  ransacker :rest, formatter: proc {|v| rests[v]}

	# chapter 1 : N option
	# 같은 챕터를 사용하는 서로 다른 튜터가 매긴 옵션

	def set_data_before_make_schdule
		@start_at, @end_at = DateTime.now, DateTime.now
		begin
			@tutor = self.tutor
			begin
				@book = self.book
				begin
					@chapters = @book.chapters
					begin
						@chapters.each{ |chapter| (@options ||= []) << chapter.options.find_by(tutor: self.tutor) if chapter.options.find_by(tutor: self.tutor) }
					rescue => exception
						puts "챕터에 대한 옵션이 없습니다."
					else
						@weight_sum ||= @options.pluck(:weight).inject(0, &:+)
					end
				rescue => exception
					puts "책에 목차가 존재하지 않습니다."
				end
			rescue => exception
				puts "프로젝트에 책이 등록되지 않았습니다."
			end
		rescue => exception
			puts "프로젝트에 튜터가 등록되지 않았습니다."
		end
	end

	# 휴식있는 스케쥴 생성
	# ( 기간 + 챕터 수) * w_i / sigma(w_i) -> 각 결과는 휴일 1일 포함된 날이 나옴
	# 챕터 수가 max를 넘어가면, max로 설정 뒤 챕터 사이에 랜덤으로 분배
	# max는 기간의 20%
	# 챕터 당 휴일 1일이 default이다. max를 넘을 경우는 max가 휴일의 수와 동일
	def make_schedule_with_rest
		
		set_data_before_make_schdule

		# DateTime.on_weekend? => 주말인지 아닌지 true : false

		@options.each_with_index do | option, index |
			@start_at = index != 0 ? @end_at + 1.days : self.started_at # 첫 인덱스면, 첫 챕터니까 이 챕터의 시작일은 프로젝트의 시작일과 같다. 정렬 순서 뒤바꾸지 않는 이상 괜찮다 created_at
			@end_at = @start_at + ((self.duration * ( option.weight.to_f / @weight_sum )).to_i - 1).days
			option.update(start_at: @start_at, end_at: @end_at)
		end
	end

	# 휴식 없는 스케쥴 생성
	# 기간 * w_i / sigma(w_i)
	# 소수점 이하 자리가 같은 경우, 상위 n개 챕터에 남은 기간(버림으로 발생하는) 랜덤으로 분배
	def make_schedule_without_rest
		
	end
end
