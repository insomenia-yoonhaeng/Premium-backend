class ProjectSerializer < Panko::Serializer
  attributes :deposit, :description, :image, :experience_period 

	#belongs_to :tutor, serializer: UserSerializer
	#has_many :tutees, each_serializer: UserSerializer
end