class AttendanceSerializer < Panko::Serializer

  attributes :id, :status, :created_at, :updated_at, :pay_status, :attendance_count

  has_one :project, each_serializer: ProjectSerializer
  has_one :tutee, each_serializer: TuteeSerializer

  def attendance_count
    Project.includes(:attendances).find(object.project.id).attendances.count if object.project.present?
  end
end