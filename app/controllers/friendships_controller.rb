class FriendshipsController < ApplicationController

  # GET /friendships
  # GET /friendships.json
  def index
    #current_page = params.fetch(:page, 1).to_f
    #@friends = @current_user.friends.paginate(:page => current_page)
    #has_more = (@friends.total_pages > current_page)

    @friends = @current_user.friends
    has_more = false

    to_json(@friends, has_more)
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @user = User.find_by(:email => friendship_params[:email])
    if @user.nil?
      render json: { error: "Cannot find user with specified email"}, status: 400
    else
      id = @user.firstName
      if Friendship.exists?(:user_id => @current_user.id, :friend_id => @user.id)
        render json: { error: 'Already Friends'}, status: 400
      else
        @friendship = @current_user.friendships.build(:friend_id => @user.id)
        if @friendship.save
          @friend_user = @friendship.friend
          @inverse_friendship = @friend_user.friendships.build(:friend_id => @current_user.id)
          if @inverse_friendship.save
            render json: @friendship, status: :created
          else
          render json: @inverse_friendship.errors, status: :unprocessable_entity
          end
        else
          render json: @friendship.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = @current_user.friendships.find_by(friendship_params)
    @inverse_friendship = @current_user.inverse_friendships.find_by(@friendship.friend_id)
    @friendship.destroy
    @inverse_friendship.destroy

    head :no_content
  end

  private

    def to_json(friendships, has_more)
      render json: {
        user_list:  {
          users:  ActiveModel::ArraySerializer.new(friendships, each_serializer: UserSerializer, root: false),
          has_more: has_more
        }
      }
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id, :email)
    end
end
