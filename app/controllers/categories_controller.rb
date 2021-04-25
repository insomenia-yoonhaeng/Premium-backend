class CategoriesController < ApiController
  before_action :current_api_user
  before_action :authorize_check_request

  def index
    render json: each_serializer(Category.all, CategorySerializer)
  end
end
