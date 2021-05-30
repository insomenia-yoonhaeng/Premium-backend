class LikeSerializer < Panko::Serializer
  attributes :id, :likable_id, :likable_type 

  has_one :likable, serializer: UserSerializer
end