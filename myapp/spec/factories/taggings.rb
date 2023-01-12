# == Schema Information
#
# Table name: taggings
#
#  id         :integer          unsigned, not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer          not null
#  task_id    :integer          not null
#
FactoryBot.define do
  factory :tagging do
    tag { nil }
    task { nil }
  end
end
