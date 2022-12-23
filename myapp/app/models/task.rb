# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :string(255)      not null
#  due_date    :datetime         not null
#  priority    :integer
#  status      :integer
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  include AASM

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true

  scope :by_title, lambda { |title|
    where(Task.arel_table[:title].matches("%#{title}%"))
  }

  enum status: {
    unstarted: 0,
    started: 1,
    completed: 2
  }

  aasm(column: 'status', enum: true)do
    state :unstarted, initial: true
    state :started, :completed

    event :start do
      transitions from: :unstarted, to: :started
    end

    event :complete do
      transitions from: :started, to: :completed
    end
  end
end
