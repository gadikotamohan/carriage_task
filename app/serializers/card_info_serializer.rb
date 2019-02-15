class CardInfoSerializer < ActiveModel::Serializer
  attributes :id, :title, :comments_count
end
