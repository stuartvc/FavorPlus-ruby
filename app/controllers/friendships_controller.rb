class FriendshipsController < ApplicationController

  # GET /friendships
  # GET /friendships.json
  def index
    @friends = @current_user.friends

    render json: { users: @friends }
  end

  # POST /friendships
  # POST /friendships.json
  def create
    if Friendship.exists?(:user_id => @current_user.id, :friend_id => friendship_params[:friend_id])
      render json: { error: 'Already Friends'}, status: 400
    else
      @friendship = @current_user.friendships.build(friendship_params)
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

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end
end
