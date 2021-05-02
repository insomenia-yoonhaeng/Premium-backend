class ProjectSerializer < Panko::Serializer
  attributes :id, :deposit, :description, :image, :experience_period, :title

	#belongs_to :tutor, serializer: UserSerializer
	#has_many :tutees, each_serializer: UserSerializer
end