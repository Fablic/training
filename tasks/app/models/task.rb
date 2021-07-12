class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 60 }
  validates :label, length: { maximum: 20 }
  validates :detail, length: { maximum: 250 }
  validate :before_datetime, if: :will_save_change_to_limit_date?

  belongs_to :priority, class_name: 'MasterTaskPriority'
  belongs_to :status, class_name: 'MasterTaskStatus'
  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :search_task_name, ->(keyword) { where(['task_name like ?', "%#{keyword}%"]) }
  scope :search_status, ->(statuses) { where(status_id: [statuses]) }
  scope :sort_task, ->(sort_conditions) { order(sort_conditions) }

  def before_datetime
    return if limit_date.blank? || limit_date > Time.current

    # 現在日時より前の日時に期限を変更している場合、エラーになる
    errors.add(:limit_date, :cannot_be_before_datetime)
  end

  def self.search(keyword, statuses, sort_conditions)
    search_keyward_ids = Task.without_deleted.search_task_name(keyword).pluck(:id)
    search_status_ids = Task.without_deleted.search_status(statuses).pluck(:id).presence || Task.without_deleted.pluck(:id)
    Task.where(id: [search_keyward_ids]).where(id: [search_status_ids]).sort_task(sort_conditions)
  end
end
