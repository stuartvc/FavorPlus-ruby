require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  setup do
    @friendship = friendships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:friendships)
  end

  test "should create friendship" do
    assert_difference('Friendship.count') do
      post :create, friendship: { friend_id: @friendship.friend_id, user_id: @friendship.user_id }
    end

    assert_response 201
  end

  test "should show friendship" do
    get :show, id: @friendship
    assert_response :success
  end

  test "should update friendship" do
    put :update, id: @friendship, friendship: { friend_id: @friendship.friend_id, user_id: @friendship.user_id }
    assert_response 204
  end

  test "should destroy friendship" do
    assert_difference('Friendship.count', -1) do
      delete :destroy, id: @friendship
    end

    assert_response 204
  end
end
