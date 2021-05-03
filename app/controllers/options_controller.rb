class OptionsController < ApiController
  def create 
    option_params.dig(:options).each do |option|
      # bulk insert
    end
  end

  def option_params
    params.fetch(:option, {}).permit(Option::PERMIT_COLUMNS)
  end
end