# frozen_string_literal: true

class Task < ApplicationRecord
  
  validates :task_name,
    presence: true, 
    length: { maximum: 20 }
  validates :description,
    length: { maximum: 100 }
  validates :status, 
    presence: true,
    inclusion: {
       in: ['todo', 'progress', 'done'] 
    }
  validates :label, 
    length: { maximum: 20 }
  validates_datetime :start_date
  validates_datetime :end_date

  def finished_at_is_after_started_at
    return if end_date.blank? || start_date.blank?
    return if end_date.to_date >= start_date.to_date
    
    errors.add(:end_date, I18n.t('tasks.errors.messages.earlier_date_error', start: I18n.t('tasks.common.start_date')))
  end

  def self.search(search)
    if search
      Task.where(['status like ?', "%#{search}%"]).order('created_at')
    else
      Task.all.order('created_at')
    end
  end
end
