module Iamport
  extend ActiveSupport::Concern
  
  IAMPORT_SERVER_URL = 'https://api.iamport.kr'.freeze

  @access_token = nil
  
  # initializer에 있는 Iamport config 받아오기
  class Config
    attr_accessor :api_key
    attr_accessor :api_secret
  end

  class << self
    
    def config
      @config ||= Config.new
    end
    
    def configure
      yield(config) if block_given?
    end

    # api사용을 위한 토큰 취득
    def iamport_access_token
      if @access_token.nil?
				# imp_key 값, imp_secret 값을 넣어야합니다.
        imp_key = ENV["IAMPORT_API_KEY"]
        imp_secret = ENV["IAMPORT_API_SECRET_KEY"]
        @access_token = HTTParty.post(
          "#{IAMPORT_SERVER_URL}/users/getToken",
          body: { imp_key: imp_key, imp_secret: imp_secret }
        ).parsed_response['response']['access_token']
      else
        @access_token
      end
    end

    # 고유번호로 결제 내역 확인
    def iamport_payment(imp_uid)
      HTTParty.get(
        "#{IAMPORT_SERVER_URL}/payments/#{imp_uid}",
        headers: { Authorization: iamport_access_token }
      ).parsed_response.values_at('code', 'response')
    end

    # 결제 취소
    def iamport_cancel(imp_uid, amount)
      HTTParty.post(
        "#{IAMPORT_SERVER_URL}/payments/cancel",
        body: {
          imp_uid: imp_uid,
          amount: amount
        },
        headers: { Authorization: iamport_access_token }
      ).parsed_response['code'].zero?
    end

    # 재결제 프로세스
    def iamport_again(customer_uid, card_id, amount)
      HTTParty.post(
        "#{IAMPORT_SERVER_URL}/subscribe/payments/again",
        body: {
          name: '빌링키 결제 테스트',
          customer_uid: customer_uid,
          merchant_uid: "card_id_#{card_id}_#{Time.current.strftime('%Y%m%d%H%M%S')}",
          amount: amount
        },
        headers: { Authorization: iamport_access_token }
      ).parsed_response.values_at('code', 'response')
    end
  end

end