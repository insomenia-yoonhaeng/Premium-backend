class AttendanceSerializer < Panko::Serializer

  attributes :id, :status, :created_at, :updated_at, :pay_status, :auth_count

  has_one :project, each_serializer: ProjectSerializer
  has_one :tutee, each_serializer: TuteeSerializer

  def auth_count
    object.auths.count if object.auths.present?
  end
end