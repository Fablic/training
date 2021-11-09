# frozen_string_literal: true

class Task < ApplicationRecord
  
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
       in: ['todo', 'inProgress', 'done'] 
    }

  def self.search(search)
    if search
      Task.where(['status like ?', "%#{search}%"])
    else
      Task.all
    end
  end
  
end
