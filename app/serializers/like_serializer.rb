class LikeSerializer < Panko::Serializer
  attributes :id, :likable_id, :likable_type 
end