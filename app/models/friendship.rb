class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :className => "User"
end
