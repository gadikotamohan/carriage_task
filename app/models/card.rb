class Card < ApplicationRecord
  validates :title, :description, presence: true
  
  belongs_to :user
  belongs_to :list
  has_many :comments, as: :resource, dependent: :destroy

  scope :comments_ordered, -> { order(comments_count: :desc)}
end
