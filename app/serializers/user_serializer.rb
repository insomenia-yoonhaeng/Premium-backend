class UserSerializer < Panko::Serializer
  attributes :id, :email, :name, :user_test

  def user_test
    object&.name + " " + object&.email rescue ""
  end
end