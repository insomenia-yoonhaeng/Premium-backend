class UserMailer < ApplicationMailer
  default :from => 'tjdals1771@gmail.com'

  def send_email(user, message = "관리자가 튜터 심사를 마무리 하였습니다.")
    @user = user
    @message = message
    mail(
      to: @user.email,
      subject: @message
    )
  end
end
