class User < ApplicationRecord
  before_save { email.downcase! }

  GENERAL = 0
  ADMIN = 1
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze

  validates :user_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true
  has_secure_password

  has_many :task_links, dependent: :destroy
  has_many :tasks, through: :task_links

  def add_task(task)
    tasks << task
  end

  def own_task?(task)
    tasks.include?(task)
  end
end
