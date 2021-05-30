class UserSerializer < Panko::Serializer
  attributes :id, :email, :name, :likes_count, :status, :image, :info, :phone, :type, :likable_ids

  # def likable_ids
  #   context[:likable_ids]
  # end
end