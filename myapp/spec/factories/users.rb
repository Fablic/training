FactoryBot.define do
  factory :normal_user, class: User do
    name { "normal" }
    email { "normal@gmail.com" }
    password { "normal" }
    admin_flg { 0 }
  end

  factory :admin_user, class: User do
    name { "admin" }
    email { "admin@gmail.com" }
    password { "admin" }
    admin_flg { 1 }
  end
end
