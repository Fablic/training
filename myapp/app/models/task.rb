# frozen_string_literal: true

class Task < ApplicationRecord
  enum status_list: {
    todo: 'todo',
    inProgress: 'inProgress',
    done: 'done',
  },  _prefix: true

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
       in: Task.status_lists.keys 
    }

  scope :search_condition, -> (search_params) do
    return if search_params.blank?
  
    task_name_like(search_params[:task_name])
      .status_is(search_params[:status])
   end
 
  scope :task_name_like, -> (task_name) { where('task_name LIKE ?', "%#{task_name}%") if task_name.present? }
  scope :status_is, -> (status) { where(status: status) if status.present? }
end
