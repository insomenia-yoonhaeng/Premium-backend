class AttendancesController < ApiController
  before_action :authorize_check_request
  before_action :load_project, only: %i(create update destroy)

  def index
    # 프로젝트에 대한 attendance index 보여주기 (tutor일 경우)
    # 튜티일 경우 
    # 튜티인 경우는 자신이 참가하는 프로젝트의 인증 보여줘야할듯
    begin
      @attendances = @current_user.attendances
      render json: each_serializer(@attendances, AttendanceSerializer), status: :ok
    rescue => exception
      render json: { errors: @attendances&.errors&.full_messages&.first }, status: :bad_request     
    end
  end

  def create
    if @current_user.is_a? Tutee
      begin
        @attendance = @current_user.attendances.where(project_id: @project.id).first_or_create
        render json: serializer(@attendance, AttendanceSerializer), status: :ok
      rescue => exception
        render json: { errors: @attendance&.errors&.full_messages&.first }, status: :bad_request     
      end
    else
      render json: { errors: "튜티만 접근 가능합니다" }, status: :not_found
    end
  end

  def show
  end

  def update
    # 체험판에서 정식판으로 등록 
    ## TODO 여기서 결제 로직 필요할듯
    if @current_user.is_a? Tutee
      begin
        @attendance = @current_user.attendances.trial.where(project_id: @project.id).first
        @attendance.full!
        render json: serializer(@attendance, AttendanceSerializer), status: :ok
      rescue => exception
        if exception.class.eql?("NoMethodError")
          render json: { errors: "체험하고 있는 프로젝트가 아닙니다"}, status: :bad_request
        end
        render json: { errors: @attendance&.errors&.full_messages&.first }, status: :bad_request     
      end
    else
      render json: { errors: "튜티만 접근 가능합니다" }, status: :not_found
    end
  end

  def destroy
    # 프로젝트 탈퇴
    if @current_user.is_a? Tutee
      begin
        @attendance = @current_user.attendances.where(project_id: @project.id).first
        if @attendance.present?
          @attendance.destroy 
          render json: {result: "성공적으로 프로젝트를 탈퇴하였습니다"}, status: :ok
        else
          render json: {result: "프로젝트에 참여중이 아닙니다"}, status: :bad_request
        end
      rescue => exception
        render json: { errors: "잘못된 요청입니다" }, status: :bad_request     
      end
    else
      render json: { errors: "튜티만 접근 가능합니다" }, status: :not_found
    end
  end


  private

	def load_project
		@project = Project.find(params[:project_id])
	end
end
