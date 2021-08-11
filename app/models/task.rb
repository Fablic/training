# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  name        :string(255)      not null
#  status      :integer          default("ToDo"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_name    (name)
#  index_tasks_on_status  (status)
#
class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  enum status: {
    ToDo: 0,
    Doing: 1,
    Done: 2,
  }
end
