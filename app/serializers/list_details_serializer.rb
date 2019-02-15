class ListDetailsSerializer < ActiveModel::Serializer
  attributes :id, :title
  attribute :cards

  def cards
    cards = self.object.cards.order(comments_count: :desc)
    ActiveModel::Serializer::CollectionSerializer.new(cards, serializer: CardInfoSerializer, root: false)
  end
end