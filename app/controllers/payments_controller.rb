class PaymentsController < ApplicationController
  include Iamport
  def create
		# code == 0 이면 결제 성공
		code, response = iamport_payment(params[:imp_uid])
		# status : 상태, paid_amount: 결제 금액, imp_uid: 이번 거래 고유값, 
		status, paid_amount, imp_uid, merchant_uid = response.values_at('status', 'amount', 'imp_uid', 'merchant_uid')
		if code.zero? && status == 'paid'
	    # 결제 성공 분기
			flash[:notice] = "결제에 성공하였습니다. 이제 에세이를 제출해보세요"
    else
			# 결제 실패
      flash[:notice] = "결제를 실패했습니다."
    end
  end
end