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
#  user_id     :bigint           not null
#
# Indexes
#
#  index_tasks_on_status   (status)
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Task < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 255 }

  enum status: {
    ToDo: 0,
    Doing: 1,
    Done: 2,
  }

  scope :by_name, ->(params) { where('name LIKE ?', "%#{params}%") }
  scope :by_status, ->(params) { where(status: params) }
end
