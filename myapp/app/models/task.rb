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
  
    task_name_like(search_params[:task_name_cont])
      .status_is(search_params[:status_eq])
   end
 
  scope :task_name_like, -> (task_name_cont) { where('task_name LIKE ?', "%#{task_name_cont}%") if task_name_cont.present? }
  scope :status_is, -> (status_eq) { where(status: status_eq) if status_eq.present? }
end
