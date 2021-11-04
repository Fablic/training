# frozen_string_literal: true

class Task < ApplicationRecord
    def self.search(search)
      if search
        Task.where(['status like ?', "%#{search}%"]).order('priority is null, priority, end_date')
      else
        Task.all.order('priority is null, priority, end_date')
      end
    end
  end
  