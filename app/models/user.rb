class User < ActiveRecord::Base
  before_create -> { self.auth_token = SecureRandom.hex }
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :transactions
  has_many :inverse_transactions, :class_name => "Transaction", :foreign_key => "friend_id"
end
