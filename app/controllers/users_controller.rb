class UsersController < ApplicationController
  skip_before_action :authenticate_user_with_token, :only => [:create]
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    current_page = params.fetch(:page, 1).to_f
    @users = User.paginate(:page => params.fetch(:page, 1))
    has_more = (@users.total_pages > current_page)

    to_json(@users, has_more);
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    if user_params[:email].nil?
      render json: { error: 'Must provide email'}, status: 400
    elsif User.exists?(:email => user_params[:email])
      render json: { error: 'Email already registered'}, status: 400
    elsif user_params[:firstName].nil?
      render json: { error: 'Must provide firstName'}, status: 400
    elsif user_params[:password].nil?
      render json: { error: 'Must provide password'}, status: 400
    else
      @user = User.new(user_params)

      if @user.save
        render json: { token: @user.auth_token }, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @current_user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    head :no_content
  end

  def home
    current_page = params.fetch(:page, 1).to_f
    @friendships = @current_user.friendships.paginate(:page => current_page)
    has_more = @current_user.friendships.size >= current_page * WillPaginate.per_page

    render json: Friendship.json_me(@friendships, has_more);
  end

  private

    def to_json(users, has_more)
      render json: {
        user_list:  {
          users:  ActiveModel::ArraySerializer.new(users, each_serializer: UserSerializer, root: false),
          has_more: has_more
        }
      }
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :firstName, :lastName, :page)
    end
end
