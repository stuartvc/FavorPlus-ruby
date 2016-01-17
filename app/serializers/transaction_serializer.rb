class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :value, :description
  has_one :user
  has_one :friend
end
