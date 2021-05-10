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

  def set_data_before_make_schedule
    @start_at, @end_at = DateTime.now, DateTime.now
    msg = ''
    begin
      @tutor = self.tutor
    rescue => exception
      msg = "프로젝트에 튜터가 등록되지 않았습니다."
      puts msg
    end
    
    begin
      @book = self.book
    rescue => exception
      msg = "프로젝트에 책이 등록되지 않았습니다."
      puts msg
    end
    
    begin
      @chapters = @book.chapters
    rescue => exception
      msg = "책에 목차가 존재하지 않습니다."
      puts msg
    end

    begin
      @chapters.each{ |chapter| (@options ||= []) << chapter.options.find_by(tutor: self.tutor) if chapter.options.find_by(tutor: self.tutor) }
      @weight_sum ||= @options.pluck(:weight).inject(0, &:+)
    rescue => exception
      msg = "챕터에 대한 옵션이 없습니다."
      puts msg
    else
      puts "데이터 설정 완료"
    end

  end

  # DateTime.on_weekend? => 주말인지 아닌지 true : false

  # 휴식 없는 스케쥴 생성
  # 기간 * w_i / sigma(w_i)
  # 소수점 이하 자리가 같은 경우, 상위 n(남은 기간(버림으로 발생하는))개 랜덤으로 분배
  # O(nlogn)
  def make_schedule_without_rest

    set_data_before_make_schedule
    @options.each do | option |
      real_ratio_alloc_day = self.duration * ( option.weight.to_f / @weight_sum )
      (@real_ratio_alloc_days ||= []) << { id: option.id, day: real_ratio_alloc_day }
    end

    diff ||= self.duration - (@real_ratio_alloc_days.pluck(:day).map(&:to_i).inject(0, &:+))

    # 상위 n개
    @recongnize_days = @real_ratio_alloc_days.sort_by{ |r| r[:day] }.last(diff)

    @options.each_with_index do | option, index |
      @start_at = index != 0 ? @end_at + 1.days : self.started_at # 첫 인덱스면, 첫 챕터니까 이 챕터의 시작일은 프로젝트의 시작일과 같다. 정렬 순서 뒤바꾸지 않는 이상 괜찮다 created_at
      real_ratio_alloc_day = self.duration * ( option.weight.to_f / @weight_sum )
      @end_at =  @start_at + (@recongnize_days.pluck(:id).include?(option.id) ? real_ratio_alloc_day.to_i.days : (real_ratio_alloc_day.to_i - 1).days)
      option.update(start_at: @start_at, end_at: @end_at)
    end

  end

  # 휴식있는 스케쥴 생성
  # ( 기간 + 챕터 수) * w_i / sigma(w_i) -> 각 결과는 휴일 1일 포함된 날이 나옴 => 휴일 1일 제외해야됨
  # 챕터 수가 max를 넘어가면, max로 설정 뒤 챕터 사이에 휴일 랜덤으로 분배
  # max는 기간의 20%
  # 챕터 당 휴일 1일이 default이다. max를 넘을 경우는 max가 휴일의 수와 동일
  def make_schedule_with_rest
    debugger
    set_data_before_make_schedule
   
    @holiday_upper_bound ||= (self.duration * 0.2).to_i
    
    @options.each do | option |
      real_ratio_alloc_day = self.duration * ( option.weight.to_f / @weight_sum )
      (@real_ratio_alloc_days ||= []) << { id: option.id, day: real_ratio_alloc_day }
    end
    
    # 실제 비율로 나눠진 기간과 버림으로 인해 잘라진 기간의 차이 => n개
    diff ||= self.duration - (@real_ratio_alloc_days.pluck(:day).map(&:to_i).inject(0, &:+))

    # 상위 n개
    @recongnize_days = @real_ratio_alloc_days.sort_by{ |r| r[:day] }.last(diff)

    # 휴일 랜덤으로 뽑는 로직
    grant_holiday_options = @options.pluck(:id).shuffle.last((@holiday_upper_bound < @options.count ? @holiday_upper_bound : @options.count))
  
    @options.each_with_index do | option, index |
      debugger
      @start_at = index != 0 ? @end_at + 1.days : self.started_at # 첫 인덱스면, 첫 챕터니까 이 챕터의 시작일은 프로젝트의 시작일과 같다. 정렬 순서 뒤바꾸지 않는 이상 괜찮다 created_at
      real_ratio_alloc_day = self.duration * ( option.weight.to_f / @weight_sum )
      @end_at =  @start_at + (@recongnize_days.pluck(:id).include?(option.id) ? real_ratio_alloc_day.to_i.days : (real_ratio_alloc_day.to_i - 1).days)
      if grant_holiday_options.include?(option.id)
        @end_at += 1.day
        option.update(start_at: @start_at, end_at: @end_at, holiday: 'holiday')  
      else
        option.update(start_at: @start_at, end_at: @end_at)
      end
    end
  
  end

end
