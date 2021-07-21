FactoryBot.define do
  ActiveRecord::Base.connection.execute('ALTER TABLE users AUTO_INCREMENT = 1')
  factory :user, class: User do
    user_name { 'テストユーザ' }
    email { 'test@test.jp' }
    password { 'password' }
    role { 0 }
  end
  factory :user_after_create_task, class: User do
    user_name { 'テストユーザ' }
    email { 'test@test.jp' }
    password { 'password' }
    role { 0 }

    after(:create) do |user|
      create(:task_link, task: create(:task_list_item), user: user)
    end
  end
end
