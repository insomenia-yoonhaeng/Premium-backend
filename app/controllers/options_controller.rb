class OptionsController < ApiController

  before_action :check_auth, only: %i[:create]

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
      options << @current_user.options.bulid(weight: option.weight, chapter_id: option.chapter_id)
    end
    Option.import options
  end

  def option_params
    params.fetch(:option, {}).permit(Option::PERMIT_COLUMNS)
  end
end