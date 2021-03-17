class UsersController < ApiController
  before_action :authorize_request, except: :create
  before_action :load_user, except: %i(index create)

  def index
    #send_response([User.all, :ok])
    @users = User.all
    render json: each_serializer(@users, UserSerializer), status: :ok
  end

  def show
    result = (@user) ? [@user, :ok] : [@user.errors.full_messages, :unprocessable_entity]
    #send_response(result)

    render json: serializer(@user, UserSerializer, [:id,:name, :user_test]), status: :ok
  end
    
  def create
    @user = User.new user_params
    result = (@user.save) ? [@user, :ok] : [@user.errors.full_messages, :unprocessable_entity]
    send_response(result)
  end
  
  def update
    result = (@user.update user_params) ? [@user, :ok] : [@user.update.errors.full_messages, ""]
    send_response(result)
  end

  def destroy
    result = (@user.destroy) ? [@user, :ok] : [@user.destroy.errors.full_messages, ""]
    send_response(result)
  end


  private
    
  def user_params
    params.require(:user).permit(User::PERMIT_COLUMNS)
  end 

  def load_user
    @user = User.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {errors: 'User not found'}, status: :not_found
  end
end
