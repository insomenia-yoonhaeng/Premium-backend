class AuthSerializer < Panko::Serializer
  attributes :id, :description, :authable_type, :authable_id
	#belongs_to :tutor, serializer: UserSerializer
	has_many :images, each_serializer: ImageSerializer
end