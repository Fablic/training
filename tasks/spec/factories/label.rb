FactoryBot.define do
  factory :label, class: Label do
    label_name { 'テストラベル名' }
  end
  factory :label_after_create_task, class: Label do
    label_name { 'テストラベル名' }

    after(:create) do |label|
      create(:label_link, label: label, task: create(:task_list_item))
    end
  end
end
