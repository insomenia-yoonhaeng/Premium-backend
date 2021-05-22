class ImageSerializer < Panko::Serializer
  attributes :id, :image, :image_url, :imageable_id, :imageable_type

  def image_url
    object.image.url if object.image.present?
  end
end