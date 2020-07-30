# frozen_string_literal: true

class Task < ApplicationRecord
  COUNT_PER_PAGE = 10
  attribute :input_task_label, :string
  attr_accessor :input_task_label
  validates :name, presence: true, length: { maximum: 100 }
  validates :due_date, presence: true
  validates :status, inclusion: { in: (0..2).to_a }

  belongs_to :app_user
  has_many :task_labels, dependent: :destroy

  # rubocop:disable Metrics/AbcSize
  def self.search_with_condition(search, page, current_user)
    condition = {}
    condition[:app_user] = current_user unless current_user&.admin?
    condition[:status] = search.status if search.status.present?

    query = Task.where(condition)
    query = query.eager_load(:task_labels).where('task_labels.name like ?', "%#{search.task_label}%") if search.task_label.present?

    query.order(updated_at: search.sort_direction)
        .order(updated_at: search.sort_direction)
        .includes(:task_labels)
        .includes(:app_user)
        .page(page).per(COUNT_PER_PAGE)
  end
  # rubocop:enable Metrics/AbcSize
end
