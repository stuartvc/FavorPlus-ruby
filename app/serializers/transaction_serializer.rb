class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :value, :description, :created_at
  has_one :user
  has_one :friend
end
