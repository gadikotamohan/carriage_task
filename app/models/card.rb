class Card < ApplicationRecord
  validates :title, :description, presence: true
  
  belongs_to :user
  has_many :comments, as: :resource
end
