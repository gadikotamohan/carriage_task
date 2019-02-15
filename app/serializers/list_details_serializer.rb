class ListDetailsSerializer < ActiveModel::Serializer
  attributes :id, :title
  attribute :cards

  def cards
    obj_cards = self.object.cards.comments_ordered
    ActiveModel::Serializer::CollectionSerializer.new(obj_cards, serializer: CardInfoSerializer, root: false)
  end
end