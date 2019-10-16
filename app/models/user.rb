class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.regex_mail

  before_save{email.downcase!}

  validates :name, presence: true, length: {maximum: Settings.max50}
  validates :email, presence: true, length: {maximum: Settings.max255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min6}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end
end
