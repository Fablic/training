FactoryBot.define do
  factory :normal_user, class: User do
    name { "normal" }
    email { "normal@gmail.com" }
    password { "normal" }
    password_confirmation { "normal" }
    admin_flg { 0 }
  end

  factory :admin_user, class: User do
    name { "admin" }
    email { "admin@gmail.com" }
    password { "admin" }
    password_confirmation { "admin" }
    admin_flg { 1 }
  end

  factory :other_user, class: User do
    name { "other" }
    email { "other@gmail.com" }
    password { "other" }
    password_confirmation { "other" }
    admin_flg { 0 }
  end
end
