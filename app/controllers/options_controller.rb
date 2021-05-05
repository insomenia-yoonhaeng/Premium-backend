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
    option_params.dig(:options).each do |option|
      options << @current_user.options.build(weight: option[:weight], chapter_id: option[:id])
    end
    Option.import options
    render json: { status: :ok }
  end

  def option_params
    params.fetch(:option, {}).permit(Option::PERMIT_COLUMNS)
  end
end