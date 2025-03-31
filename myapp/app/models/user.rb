class User < ApplicationRecord
  has_many :tasks
  has_secure_password
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    transaction do
      tasks.active.find_each(&:soft_delete)
      update_column(:deleted_at, Time.current)
    end
  end
end
