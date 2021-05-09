class OptionsController < ApiController

  before_action :check_auth, only: %i[:create]
  before_action :authorize_check_request
  # {
  #   "option": {
  #     "options": [
  #        {"weight": 1, chapter_id: 4}, 
  #        {"weight": 1, chapter_id: 5}
  #     ]
  #   }
  # }

  def create
    options = []
    # 튜터는 동시에 두 개이상의 프로젝트를 진행할 수 없음, 튜터가 기존에 만들어놨던 가중치와 관련된 것들은 비워줘야 함
    @current_user.options.destroy_all if @current_user.options.present?
    # 챕터부터 옵션까지 역탐색
    book = Chapter.find_by(id: option[:id])&.book
    tutor = book.projects.find_by(tutor: @current_user).tutor
    option_params.dig(:options).each do |option|
      options << tutor.options.build(weight: option[:weight], chapter_id: option[:id])
    end
    Option.import options
    render json: { status: :ok }
  end

  def option_params
    params.fetch(:option, {}).permit(Option::PERMIT_COLUMNS)
  end
end