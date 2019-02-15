class User < ApplicationRecord
  include BCrypt
  PER_PAGE=10
  has_many :authentications, dependent: :destroy#, counter_cache: true
  has_many :sessions, dependent: :destroy#, counter_cache: true
  has_many :cards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :list_users
  has_many :lists, through: :list_users

  validates :email, :first_name, :last_name, presence: true

  enum role: [:member, :admin], _prefix: true
  attr_accessor :current_session
end