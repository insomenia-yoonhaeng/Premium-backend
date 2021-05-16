class ProjectSerializer < Panko::Serializer
  attributes :id, :deposit, :description, :image, :experience_period, :title

  
	has_one :tutor, serializer: UserSerializer
	#has_many :tutees, each_serializer: UserSerializer
end