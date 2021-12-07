# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  belongs_to :label
  belongs_to :task

  validates :task_id, { presence: true }
  validates :label_id, { presence: true }

  def self.create_link(task, label)
    tl = label.task_labels.build
    tl.task = task
    return false unless tl.save

    true
  end
end
