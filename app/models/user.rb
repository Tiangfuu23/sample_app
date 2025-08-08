class User < ApplicationRecord
  has_secure_password
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MAX_LENGTH_NAME = 50
  MAX_LENGTH_EMAIL = 255
  MAX_AGE_YEARS = 100
  USER_PERMIT =
    %i(name email birthday gender password password_confirmation).freeze

  enum gender: {male: 0, female: 1, other: 2}

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: MAX_LENGTH_NAME}
  validates :email, presence: true, length: {maximum: MAX_LENGTH_EMAIL},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :birthday, presence: true
  validates :gender, presence: true, allow_nil: true
  validate :birthday_within_range

  scope :newest, ->{order(created_at: :desc)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
    remember_token
  end

  def session_token
    remember_token || remember
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def birthday_within_range
    return if birthday.nil?

    current_date = Time.zone.today

    if birthday < Time.zone.today.prev_year(MAX_AGE_YEARS) # 100 years ago
      errors.add(:birthday, :in_past)
    elsif birthday > current_date
      errors.add(:birthday, :in_future)
    end
  end
end
