# frozen_string_literal: true

class Task < ApplicationRecord
  def self.search(search)
    if search
      Task.where(['status like ?', "%#{search}%"])
    else
      Task.all
    end
  end
end
