class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: { minimum: 3, maximum: 20 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: true }
  validates :password, presence: true, length: { minimum: 5, maximum: 20 }, on: :create
  has_secure_password

  enum roles: { member: 0, adminer: 10, owner: 20 }
  validates :role, presence: true, inclusion: { in: User.roles.values }, user_role: true

  has_many :tasks, dependent: :destroy

  attribute :role, :integer, default: 0

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
