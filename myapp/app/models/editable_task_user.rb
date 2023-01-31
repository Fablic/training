# == Schema Information
#
# Table name: editable_task_users
#
#  id         :integer          unsigned, not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :integer          not null
#  user_id    :integer          not null
#
class EditableTaskUser < ApplicationRecord
  belongs_to :task
  belongs_to :user
end
