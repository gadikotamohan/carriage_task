class Authentication < ApplicationRecord
  self.inheritance_column = 'provider'

  belongs_to :user
  has_many :sessions, dependent: :destroy
end