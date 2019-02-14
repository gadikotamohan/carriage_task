class User < ApplicationRecord
  include BCrypt
  PER_PAGE=10
  has_many :authentications, dependent: :destroy#, counter_cache: true
  has_many :sessions, dependent: :destroy#, counter_cache: true
  has_and_belongs_to_many :lists

  validates :email, :first_name, :last_name, presence: true

  enum role: [:member, :admin], _prefix: true
  attr_accessor :current_session
end