# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: [:not_started, :in_progress, :completed]
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 30000 }

  def self.enum_options_for_select
    return self.statuses.map{ |status, i| self.human_attribute_name(status) }
  end
end
