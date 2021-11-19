# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  belongs_to :label
  belongs_to :task

  validates :task_id, { presence: true }
  validates :label_id, { presence: true }
end
