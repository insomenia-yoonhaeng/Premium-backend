class AttendanceSerializer < Panko::Serializer

  has_one :project, each_serializer: ProjectSerializer
  has_one :user, each_serializer: UserSerializer
end