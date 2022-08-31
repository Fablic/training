FactoryBot.define do
  factory :label do
    name { 'name' }
    task_id { FactoryBot.create(:task).id }
  end
end
