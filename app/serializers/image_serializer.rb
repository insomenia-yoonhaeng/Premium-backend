class ImageSerializer < Panko::Serializer
  attributes :id, :image, :imageable_id, :imageable_type

end