class AuthSerializer < Panko::Serializer
  attributes :id, :description, :authable_type, :authable_id, :created_at, :tutee
	
	#belongs_to :tutor, serializer: UserSerializer
	has_one :tutee, serializer: UserSerializer
	has_many :images, each_serializer: ImageSerializer

	def tutee
		context[:tutee] if context[:tutee].present?
	end
end