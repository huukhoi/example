class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.regex_mail

  attr_accessor :remember_token
  before_save{email.downcase!}

  validates :name, presence: true, length: {maximum: Settings.max50}
  validates :email, presence: true, length: {maximum: Settings.max255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min6}

  has_secure_password

  validates :password, presence: true, length: {minimum: Settings.min6},
    allow_nil: true

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update remember_digest: nil
  end
end
