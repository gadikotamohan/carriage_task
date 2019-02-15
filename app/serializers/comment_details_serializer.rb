class CommentDetailsSerializer < ActiveModel::Serializer
  attributes :id, :content, :replies
  belongs_to :parent, serializer: CommentInfoSerializer
  belongs_to :user, serializer: UserSerializer
  def replies
    ActiveModel::Serializer::CollectionSerializer.new(self.object.replies.includes(:user), serializer: CommentInfoSerializer, root: false)
  end
end
