class List < ApplicationRecord
  belongs_to :user, counter_cache: true
  validates :title, presence: true
end
