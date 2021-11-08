# frozen_string_literal: true

class Task < ApplicationRecord
  def self.search(search)
    if search
      Task.where(['status like ?', "%#{search}%"]).order('created_at desc')
    else
      Task.all.order('created_at desc')
    end
  end
end
