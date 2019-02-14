require "securerandom"
class Session < ApplicationRecord
  belongs_to :user
  belongs_to :authentication
  validates :device_id,      presence: true
  validates :client_name,    inclusion: { in: %w(WebBrowser AndroidApp iOSApp), message: "%{value} is not a valid Client Name" }
  validates :client_version, presence: true

  before_create :generate_token

  def valid_session?
    !(expires_at.present? && expires_at < Time.now)
  end

  def generate_token
    loop do
      self.token = SecureRandom.hex(16)
      break unless Session.exists?(token: self.token)
    end
  end

end
