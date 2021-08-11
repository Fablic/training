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
FactoryBot.define do
  factory :task do
    name { 'do homework' }
    description { 'Deadline is August 31.' }
    status { 'Doing' }
  end
end
