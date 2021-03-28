class ApiController < ActionController::API
  #skip_before_action :verify_authenticity_token
  attr_reader :current_user


  def not_found
    render json: { error: 'not_found' } 
  end
  
  
  protected

  ## JWT 토큰 검증
  def authorize_request
    begin
			raise auth_token.class if auth_token.is_a? Exception
			@current_user = User.find(auth_token[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: '비유효한 토큰입니다.' }, status: :not_found
    rescue
      render json: { message: '서버처리에서 문제가 발생했습니다.' }, status: :internal_server_error
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

	def serializer object, serializer, attributes = []
		serializer.new(only: attributes).serialize(object)
	end

	def each_serializer objects, serializer
		Panko::ArraySerializer.new(
			objects,
			each_serializer: serializer
		).to_a
	end
end
