class AttendanceSerializer < Panko::Serializer

  attributes :id, :status, :created_at, :updated_at

  has_one :project, each_serializer: ProjectSerializer
  has_one :tutee, each_serializer: TuteeSerializer
end