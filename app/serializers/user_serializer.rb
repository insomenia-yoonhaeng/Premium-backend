class UserSerializer < Panko::Serializer
  attributes :id, :email, :name, :likes_count, :status, :image, :info, :phone, :type
end