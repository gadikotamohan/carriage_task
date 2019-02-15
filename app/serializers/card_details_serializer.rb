class CardDetailsSerializer < ActiveModel::Serializer
  attributes :id, :title, :description
  attribute :comments
  def comments
    obj_comments = self.object.comments.includes(:user).limit(3)
    ActiveModel::Serializer::CollectionSerializer.new(obj_comments, serializer: CommentInfoSerializer, root: false)
  end
end