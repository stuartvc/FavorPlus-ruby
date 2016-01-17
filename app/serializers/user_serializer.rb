class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstName, :lastName, :email
end
