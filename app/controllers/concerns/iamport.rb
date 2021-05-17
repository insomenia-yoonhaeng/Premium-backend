module Iamport
  extend ActiveSupport::Concern
  BASE_URL = '<https://api.iamport.kr>'
  
  @access_token = nil

  included do
    def iamport_access_token
      if @access_token.nil?
				# imp_key 값, imp_secret 값을 넣어야합니다.
        imp_key = ENV["IAMPORT_API_KEY"]
        imp_secret = ENV["IAMPORT_API_SECRET_KEY"]
        @access_token = HTTParty.post(
          "#{BASE_URL}/users/getToken",
          body: { imp_key: imp_key, imp_secret: imp_secret }
        ).parsed_response['response']['access_token']
      else
        @access_token
      end
    end

    # 해당 response 받기
    def iamport_payment(imp_uid)
      HTTParty.get(
        "#{BASE_URL}/payments/#{imp_uid}",
        headers: { Authorization: iamport_access_token }
      ).parsed_response.values_at('code', 'response')
    end

    def iamport_cancel(imp_uid, amount)
      HTTParty.post(
        "#{BASE_URL}/payments/cancel",
        body: {
          imp_uid: imp_uid,
          amount: amount
        },
        headers: { Authorization: iamport_access_token }
      ).parsed_response['code'].zero?
    end

    def iamport_again(customer_uid, card_id, amount)
      HTTParty.post(
        "#{BASE_URL}/subscribe/payments/again",
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