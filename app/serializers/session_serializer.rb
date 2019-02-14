class SessionSerializer < ActiveModel::Serializer
  attributes :token
  attribute :user_id, key: :id

  attribute :user do
    {
      id: user&.id,
      first_name: user&.first_name,
      last_name: user&.first_name,
      email: user&.email 
    }
  end

  def user
    object.user
  end

end
