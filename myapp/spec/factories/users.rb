FactoryBot.define do
  factory :user, class: User do
    email { "admin@tm.com" }
    password_digest { "$2a$12$NPcgfEO8vN91/zbwM5KwP.9NsKMVtEorU/Lk9tOw4SBxfMQ2tsjOO" }
    role { 1 }
    name { "admin" }
  end
end
