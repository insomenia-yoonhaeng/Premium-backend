class PaymentsController < ApiController
  include Iamport
  def create
		# code == 0 이면 결제 성공
		code, response = Iamport.iamport_payment(params[:imp_uid])
		# status : 상태, paid_amount: 결제 금액, imp_uid: 이번 거래 고유값, 
		status, paid_amount, imp_uid, merchant_uid = response.values_at('status', 'amount', 'imp_uid', 'merchant_uid')
		if code.zero?
	    # 결제 성공 분기
			render json: { status: status, 
                     paid_amount: paid_amount, 
                     imp_uid: imp_uid, 
                     merchant_uid: merchant_uid
                    }, status: :ok
    else
			# 결제 실패
      render json: {error: "결제에 실패했습니다."}, status: :bad_request
    end
  end
end