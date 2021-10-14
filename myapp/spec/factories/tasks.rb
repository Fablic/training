FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task#{n - 1}" }
    description { 'description' }
<<<<<<< HEAD
    status { 'new' }
=======
>>>>>>> origin/u-Hashimoto

    # created_atに対して時間をズラして作成
    factory :task_seq_created_at do
      sequence(:created_at) { |n| Time.local(2021, 1, 1, 0, 0, 0) + n.hours }
    end
    # 期限に対して日付をズラして作成
    factory :task_seq_due_date do
      sequence(:due_date) { |n| Time.local(2021, 1, 1, 0, 0, 0) + n.days }
      sequence(:created_at) { Time.local(2021, 1, 1, 0, 0, 0) }
    end
  end
end
