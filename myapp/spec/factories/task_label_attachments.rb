FactoryBot.define do
  factory :task_label_attachment do
    transient do
      user { create(:user) }
    end

    task { association :task, user: user }
    label { association :label, user: user }
  end
end
