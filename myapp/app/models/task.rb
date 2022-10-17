# frozen_string_literal: true

class Task < ApplicationRecord
  DEFAULT_PRIORITY_VALUE = 'normal'
  DEFAULT_STATUS_VALUE = 'untouched'
  DEFAULT_SORT_TYPE_VALUE = 'created_at_asc'
  SORT_TYPE = {
    'created_at_asc' => 'created_at ASC',
    'created_at_desc' => 'created_at DESC',
    'end_date_asc' => 'end_date ASC',
    'end_date_desc' => 'end_date DESC'
  }.freeze

  after_initialize :set_default_values

  belongs_to :user, optional: true
  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels

  validates :name, presence: true, length: { maximum: 255 }
  validates :priority, presence: true
  validates :status, presence: true

  enum :priority, {
    low: 0,    # 低
    normal: 1, # 普通
    high: 2    # 高
  }, prefix: true

  enum :status, {
    untouched: 0, # 未着手
    touched: 1,   # 着手中
    completed: 2  # 完了
  }, prefix: true

  scope :sort_by_keyword, ->(sort) { order(SORT_TYPE[sort]) }
  scope :search_by_keyword, lambda { |keyword|
                              where(['name LIKE(?) OR explanation LIKE(?)', "%#{sanitize_sql_like(keyword)}%", "%#{sanitize_sql_like(keyword)}%"])
                            }
  scope :search_by_status, ->(status) { where(status:) }
  scope :match_any_of_label_ids, ->(label_ids) { joins(:task_labels).merge(TaskLabel.where(label_id: label_ids)) }

  def set_default_values
    self.priority ||= DEFAULT_PRIORITY_VALUE
    self.status   ||= DEFAULT_STATUS_VALUE
  end

  class << self
    def check_approved_sort_params(sort)
      SORT_TYPE.keys.include?(sort) ? sort : DEFAULT_SORT_TYPE_VALUE
    end
  end
end
