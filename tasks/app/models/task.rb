class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 60 }
  validates :label, length: { maximum: 20 }
  validates :detail, length: { maximum: 250 }
  validate :before_datetime

  belongs_to :priority, class_name: 'MasterTaskPriority'
  belongs_to :status, class_name: 'MasterTaskStatus'
  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :created_at_desc, -> { order(created_at: :desc) }

  def before_datetime
    # 期限がNULLでない＆期限の日時が変更されている＆現在日時より前の日時に期限を変更している場合、エラーになる
    errors.add(:limit_date, :cannot_be_before_datetime)\
      if !limit_date.nil? && limit_date_was != limit_date && limit_date <= Time.current
  end
end
