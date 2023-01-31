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
require 'rails_helper'

RSpec.describe EditableTaskUser, type: :model do
  describe 'associations' do
    it { should belong_to(:user).class_name('User') }
    it { should belong_to(:task).class_name('Task') }
  end
end
