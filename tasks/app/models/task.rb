class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 60 }
  validates :label, length: { maximum: 20 }
  validates :detail, length: { maximum: 250 }
  validate :before_datetime, if: :will_save_change_to_limit_date?

  belongs_to :priority, class_name: 'MasterTaskPriority'
  belongs_to :status, class_name: 'MasterTaskStatus'
  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :created_at_desc, -> { order(created_at: :desc) }

  def before_datetime
    return if limit_date.blank? || limit_date > Time.current

    # 現在日時より前の日時に期限を変更している場合、エラーになる
    errors.add(:limit_date, :cannot_be_before_datetime)
  end
end
