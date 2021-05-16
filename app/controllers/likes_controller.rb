class LikesController < ApiController
  before_action :authorize_check_request

  def is_like
    begin
      like = @current_user.likes.find_by(likable_type: like_params[:likable_type], likable_id: like_params[:likable_id])
      if like.present? 
        render json: serializer(like, LikeSerializer), status: :ok
      else
        render json: { result: false }, status: :not_found
      end
    rescue => exception
      render json: {error: "좋아요 조회에서 문제가 발생했습니다."}, status: :bad_request
    end
  end

  def create
    begin
      like = @current_user.likes.find_or_create_by(likable_type: like_params[:likable_type], likable_id: like_params[:likable_id])
      render json: serializer(like, LikeSerializer), status: :ok
    rescue => exception
      render json: {error: "좋아요 생성에서 문제가 발생했습니다."}, status: :not_found
    end
  end

  def destroy
    begin
      like = Like.find(params[:id])
      like.destroy if like.present?
      render json: serializer(like, LikeSerializer), status: :ok
    rescue => exception
      render json: {error: "좋아요 삭제에서 문제가 발생했습니다."}, status: :not_found
    end
  end

  private
  
  def like_params
    params.fetch(:like,{}).permit(:likable_type, :likable_id)
  end
end
