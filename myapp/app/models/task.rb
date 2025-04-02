class Task < ApplicationRecord
  belongs_to :user, counter_cache: true
  scope :active, -> { where(deleted_at: nil) }

  enum priority: { low: 0, medium: 1, high: 2 }
  enum status:   { to_do: 0, in_progress: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 256 }
  validates :priority, presence: true
  validates :status, presence: true
  validates :deadline, presence: true
  validate :deadline_not_in_past

  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "status", "priority", "deadline", "created_at"]
  end

  def soft_delete
    update!(deleted_at: Time.current)
  end

  private

  def deadline_not_in_past
    return if deadline.blank?
    if deadline < Time.current
      errors.add(:deadline, I18n.t("errors.messages.deadline_in_past"))
    end
  end
end
