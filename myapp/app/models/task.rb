# frozen_string_literal: true

class Task < ApplicationRecord
  def self.search(search)
    if search
      Task.where(['status like ?', "%#{search}%"]).order('start_date')
    else
      Task.all.order('start_date')
    end
  end
end
