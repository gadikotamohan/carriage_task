class CommentInfoSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :user, serializer: UserSerializer
end
