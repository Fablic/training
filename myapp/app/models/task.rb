# frozen_string_literal: true

class Task < ApplicationRecord
  enum status_list: {
    todo: 'todo',
    inProgress: 'inProgress',
    done: 'done',
  }, _prefix: true

  validates :task_name,
            presence: true,
            length: { maximum: 20 }
  validates :description,
            length: { maximum: 100 }
  validates :label,
            length: { maximum: 20 }
  validates :status,
            presence: true,
            inclusion: {
              in: Task.status_lists.keys,
            }
  validate :valid_date_from_to?

  def valid_date_from_to?
    return unless self.start_date.present? && self.end_date.present?
    
    errors.add(:end_date, I18n.t('activerecord.errors.messages.earlier_date_error', start: I18n.t('tasks.common.end_date'))) unless
      self.start_date < self.end_date 

  scope :search_condition, lambda { |search_params|
                             return if search_params.blank?

                             task_name_like(search_params[:task_name_cont])
                               .status_is(search_params[:status_eq])
                           }

  scope :task_name_like, -> (task_name_cont) { where('task_name LIKE ?', "%#{task_name_cont}%") if task_name_cont.present? }
  scope :status_is, -> (status_eq) { where(status: status_eq) if status_eq.present? }
end
