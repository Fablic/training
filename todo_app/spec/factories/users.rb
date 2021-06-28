FactoryBot.define do
  factory :admin_user do
    username { "admin" }
    email { "admin@a.com" }
    password_digest { "AAAA1234" }
    role { :admin }
  end

  factory :normal_user do
    username { "normal" }
    email { "normal@a.com" }
    password_digest { "BBBB1234" }
    role { :normal }
  end
end
