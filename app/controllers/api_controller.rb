class ApiController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authorize_access_request!, if: :authorize_controller?
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  def not_found
    render json: { error: 'not_found' } 
  end
  
  def check_auth
    # 튜터가 인증이 되었는지 & auth 모델이 있는지 체크
    ## false일 경우는 인증이 되어 있지 않은 경우 
    (@current_user.is_a? Tutor) ? (@current_user.auths.present? && @current_user.approved?) : false
  end

	def check_user_type
	  return render json: {error: "접근 권한이 없습니다." }, status: :unauthorized unless @current_user.is_a? Tutor
	end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::PERMIT_COLUMNS)
    devise_parameter_sanitizer.permit(:account_update, keys: User::PERMIT_COLUMNS)
  end
  
  protected
  
  def authorize_check_request
    raise JWTSessions::Errors::Unauthorized unless request.headers.include? "Authorization"
    begin
      authorize_access_request!
      @current_user ||= User.find(payload["user_id"])
    rescue JWTSessions::Errors, ActiveRecord::RecordNotFound, JWT::DecodeError => exception
      puts exception.class
      Rails.logger.info exception
      @current_user = nil
      raise JWTSessions::Errors::Unauthorized
    rescue => exception
      puts exception.class
      Rails.logger.info exception
      @current_user = nil
    end
  end

	
  # def check_authentication
  #   @objects = params[:controller].classify.constantize.find_by(id: params[:id])
  #   (params[:controller].eql?("posts")) ? @objects = @objects.tag_list.reject(&:empty?).map(&:to_i) : @objects.user_ids
  #   send_response([@objects, :unauthorized]) unless @objects.include? current_user.id
  # end

  private

  def send_response(result)

    case (status = result[1])
    when :not_found then return_value = "Token Not Found"
    when :unprocessable_entity then return_value = "Bad request"
    when :internal_server_error then return_value = "Internal error"
    when :unauthorized then return_value = "Unauthorized"
    when :ok then return_value = result[0] 
    else return_value = "Failed" end

    render json: return_value, status: status
  end 

  def create_params
    begin
      @params = (request.post? || request.put?) ? JSON.parse(request.body.read) : request.params
      ActionController::Parameters.new(@params)
    rescue
      {}
    end
  end

  ## 헤더에 있는 정보 중, Authorization 내용(토큰) 추출
  def http_token
    http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  ## 토큰 해석 : 토큰 해석은 lib/json_web_token.rb 내의 decode 메소드에서 진행됩니다.
  def auth_token
    auth_token ||= JsonWebToken.decode(http_token)
  end

  ## 토큰 해석 후, Decode 내용 중 User id 정보 확인
  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

	def serializer object, serializer, context = nil, attributes = []
		serializer.new(only: attributes, context: context).serialize(object)
	end

	def each_serializer objects, serializer, context: nil
		Panko::ArraySerializer.new(
			objects,
      context: context,
			each_serializer: serializer
		).to_a
	end

  def not_authorized
    render json: { error: "Not authorized" }, status: :unauthorized
  end
end
