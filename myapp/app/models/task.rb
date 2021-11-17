# frozen_string_literal: true

class Task < ApplicationRecord
  def self.search(search)
    if search
<<<<<<< HEAD
      Task.where(['status like ?', "%#{search}%"]).order('created_at desc')
    else
      Task.all.order('created_at desc')
=======
      Task.where(['status like ?', "%#{search}%"]).order('priority is null, priority, end_date')
    else
      Task.all.order('priority is null, priority, end_date')
>>>>>>> origin/ichinoseken
    end
  end
end
