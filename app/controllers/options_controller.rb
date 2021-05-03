class OptionsController < ApiController

  # {
  #   "option": {
  #               "options": [
  #                           {"title": "A 주어와 동사, 수 일치, 시제", "weight": 1}, 
  #                           {"title": "B 태, 조동사, 가정법", "weight": 1}
  #                          ]
  #             }
  # }

  def create 
    option_params.dig(:options).each do |option|
      # bulk insert
    end
  end

  def option_params
    params.fetch(:option, {}).permit(Option::PERMIT_COLUMNS)
  end
end