class BasicAuthentication < Authentication
  include BCrypt
  store_accessor :credentials, :encrypted_password

  def provider_name
    "Email"
  end

  def password=(password)
    self.encrypted_password = Password.create(password) if password.present?
  end
end