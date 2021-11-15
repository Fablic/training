# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :task_labels, dependent: :nullify
  has_many :tasks, through: :task_labels
  scope :active, -> { where(deleted: 0) }

  validates :name, { presence: true, length: { maximum: 20 } }

  def self.create_labels(task, label_names)
    return true if label_names.blank?

    current_task_label = TaskLabel.where(task_id: task.id)
    current_task_label.delete_all

    @labels = label_names.split(',')

    @labels.each do |label|
      if self.active.where(name: label).count.zero?
        label_for_save = self.new(name: label)
        return false unless label_for_save.save
      else
        label_for_save = self.active.find_by(name: label)
      end

      TaskLabel.create_link(task, label_for_save)
    end
  end
end
