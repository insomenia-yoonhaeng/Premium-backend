class AttendancesController < ApplicationController
  before_action :authorize_check_request
  before_action :load_project, only: %i(create update)
  def index

  end

  def create
    if @current_user.is_a? Tutee
      begin
        @attendance = @current_user.create(project_id: project)
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
  end

  private

	def load_project
		project = Project.find(params[:project_id])
	end
end
