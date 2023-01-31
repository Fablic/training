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
FactoryBot.define do
  factory :editable_task_user do
    task { nil }
    user { nil }
  end
end
