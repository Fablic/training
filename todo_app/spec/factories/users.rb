FactoryBot.define do
  factory :admin_user, class: User do
    username { 'admin' }
    email { 'admin@example.com' }
    password_digest { '$2a$08$QwaU8tAaIYMIvzoBg1rG/.D5gCyuQD7Jd30b.R.3EP1PuMzfTbKbi' }
    role { :admin }
  end

  factory :normal_user, class: User do
    username { 'normal' }
    email { 'normal@example.com' }
    password_digest { '$2a$08$QwaU8tAaIYMIvzoBg1rG/.D5gCyuQD7Jd30b.R.3EP1PuMzfTbKbi' }
    role { :normal }
  end
end
