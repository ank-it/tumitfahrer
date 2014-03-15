class Api::V1::UsersController < ApiController
  respond_to :xml, :json

  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: @users }
      format.xml { render xml: @users }
    end
  end

  def show

    # check if there an authentication header, if so consume it and return more
    if !request.headers[:Authorization].nil?
      email, hashed_password = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
    end

    @user = User.find_by(id: params[:id])
    if !@user
      @user = User.find_by(email: email)
    end

    if @user && !email.nil? && !hashed_password.nil? && @user.authenticate(hashed_password)

      logger.debug "WE ARE HERE : #{email} and #{hashed_password} and #{@user}"
      respond_to do |format|
        format.json { render json: @user, serializer: LegacyUserSerializer }
        format.xml { render xml: @user }
      end
    else
      respond_to do |format|
        format.json { render json: @user, serializer: LegacyUserSerializer}
        format.xml { render xml: {:email => @user[:email]} }
      end
    end
  end

  def create
    logger.debug "Creating user for params: #{user_params}"
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.json { render json: {:message => "User added to the database", :api_key => @user.api_key, :id => @user.id} }
        format.xml { render xml: {:username => "true", :mail => "true", :id => @user.id} }
      end
    else
      respond_to do |format|
        format.json { render json: {:message => "User couldn't be added to the database"} }
        format.xml { render xml: {:username => "false", :mail => "false"} }
      end
    end

  end

  private
  def authenticate_user
    @current_user = User.find_by_api_key(params[:api_key])
  end

  def current_user
    @current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :department, :password, :password_confirmation)
  end

end