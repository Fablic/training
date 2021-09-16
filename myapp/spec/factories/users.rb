FactoryBot.define do
  factory :user do
    name { 'test_name' }
    password { 'password' }
  end
  factory :admin_user, class: User do
    name { 'admin_name' }
    password { 'passwordadmin' }
    role { :admin }
  end
end
