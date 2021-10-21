FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "名前#{n}" }
    sequence(:mail_address) { |n| "test-#{n}@sample.mail.com" }
    password {'test'}

    factory :user1 do
      id { 1 }
    end
  end
end
