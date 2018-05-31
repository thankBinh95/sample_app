class User < ApplicationRecord
  before_save{email.downcase!}
  validates :name,  presence: true, length: {maximum: Settings.length_max.name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum:
    Settings.length_max.email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum:
    Settings.length_max.password}, allow_nil: true

  def self.digest string
    if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine.MIN_COST
    else
      cost = BCrypt::Engine.cost
    end
    BCrypt::Password.create string, cost: cost
  end
<<<<<<< HEAD

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  scope :ordered_by_name, ->{order(name: :asc)}
=======
>>>>>>> parent of 5adf118... Merge pull request #5 from thankBinh95/chapter_9
end
