FactoryBot.define do
  ### System のテストデータ
  factory :task_not_started, class: Task do
    sequence(:title)    { |n| "テスト#{n}" }
    sequence(:content)  { |n| "こちらはテスト#{n}の内容です。テストテストテストテストテストテストテスト" }
    user_id             { 1 }
    label               { 'テスト' }
  end

  ### Model のsearch用テストデータ
  factory :task_search_test_A1, class: Task do
    title               { 'titleA' }
    content             { 'content' }
    user_id             { 1 }
    label               { 'label' }
    status              { '1' }
  end

  factory :task_search_test_A2, class: Task do
    title               { 'titleA' }
    content             { 'content' }
    user_id             { 1 }
    label               { 'label' }
    status              { '2' }
  end

  factory :task_search_test_B1, class: Task do
    title               { 'titleB' }
    content             { 'content' }
    user_id             { 1 }
    label               { 'label' }
    status              { '1' }
  end

  factory :task_search_test_B2, class: Task do
    title               { 'titleB' }
    content             { 'content' }
    user_id             { 1 }
    label               { 'label' }
    status              { '2' }
  end

end
