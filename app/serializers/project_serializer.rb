class ProjectSerializer < Panko::Serializer
  attributes :id, :description, :deposit ,:image ,:title ,:started_at ,:duration ,:experience_period ,:category_id ,:required_time ,:review_weight ,:mission ,:book_id ,:rest, :attendance_presence
  
	has_one :tutor, serializer: UserSerializer

  def attendance_presence
    self.attendances.present?
  end
end