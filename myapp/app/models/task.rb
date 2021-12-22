class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  enum status: { not_started: 0, in_progress: 1, done: 2 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1024 }
  validates :deadline_at, presence: true
  validate  :deadline_at_is_feature_datetime
  validates :status, presence: true
  validates :user_id, presence: true

  private

  def deadline_at_is_feature_datetime
    errors.add(:deadline_at, 'は、未来日時を登録して下さい') if !deadline_at.nil? && (deadline_at <= DateTime.now)
  end
end
