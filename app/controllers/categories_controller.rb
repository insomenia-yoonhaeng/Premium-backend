class CategoriesController < ApiController
  before_action :authorize_request

  def index
    render json: each_serializer(Category.all, CategorySerializer)
  end
end
