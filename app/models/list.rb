class List < ApplicationRecord
  validates :title, presence: true

  has_many :cards, dependent: :destroy
  has_many :list_users
  has_many :users, through: :list_users

  attr_accessor :remove_user_ids, :add_user_ids

  before_save :add_from_user_ids, if: -> { self.add_user_ids.present? }
  before_save :remove_from_user_ids, if: ->{ self.remove_user_ids.present? }

  private
    def add_from_user_ids
      self.user_ids = (self.user_ids + self.add_user_ids).uniq.compact.reject(&:blank?)
    end

    def remove_from_user_ids
      self.user_ids = self.user_ids - self.remove_user_ids.uniq.compact.reject(&:blank?)
    end
end
