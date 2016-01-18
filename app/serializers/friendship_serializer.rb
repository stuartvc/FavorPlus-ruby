class FriendshipSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
  has_one :friend
  has_one :transaction_total
end
