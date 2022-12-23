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
FactoryBot.define do
  factory :task do
    title { 'Buy chair' }
    description { 'Buy a good desk chair to asap!' }
    due_date { DateTime.tomorrow }

    trait :started do
      status { 'started' }
    end

    trait :completed do
      status { 'completed' }
    end
  end
end
