# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels

  enum priority: {
    low: 0, # 優先度低
    normal: 1, # 優先度中
    high: 2, # 優先度高
  }

  enum progress: {
    Todo: 0,
    InProgress: 1,
    Done: 2,
  }

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :due_at, presence: true
  validates :priority, inclusion: { in: Task.priorities.keys }
  validates :progress, inclusion: { in: Task.progresses.keys }

  scope :search_name, -> (keyword_name) { where(['tasks.name like?', "%#{keyword_name}%"]) }
  scope :search_progress, -> (keyword_progress) { where(progress: Task.progresses[keyword_progress]) if keyword_progress.present? }
  scope :search_user_id, -> (user_id) { where(user_id: user_id) }
  scope :sort_column_direction, -> (column, direction) { order(sort_column(column) => sort_direction(direction)) }
  scope :search_label_id, -> (keyword_label_id) { where(labels: {id: keyword_label_id}) if keyword_label_id.present? }

  with_options if: :due_at.presence do
    validate :due_at_start_check
  end

  def due_at_start_check
    errors.add(:due_at, :start_check) if due_at < Time.current
  end

  def self.sort_direction(direction)
    %i[asc desc].include?(:"#{direction}") ? :"#{direction}" : :desc
  end

  def self.sort_column(column)
    Task.column_names.include?(column) ? :"#{column}" : 'created_at'
  end
end
