FactoryBot.define do
  factory :task, class: Task do
    sequence(:title)    { |n| "テスト#{n}" }
    sequence(:content)  { |n| "こちらはテスト#{n}の内容です。テストテストテストテストテストテストテスト" }
    label               { 'テスト' }
    user_id             { FactoryBot.create(:user).id }

  end
end
