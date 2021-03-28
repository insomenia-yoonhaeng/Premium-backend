class UserSerializer < Panko::Serializer
  attributes :id, :email, :name, :user_test, :likes_count, :status, :image, :info, :phone

  def user_test
    object&.name + " " + object&.email rescue ""
  end
end