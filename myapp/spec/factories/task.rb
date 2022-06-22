FactoryBot.define do
  factory :task do
    name {"散歩"}
    description {"多摩川を歩く"}
    priority {1}
    status {1}
    limit {"2022-6-20".to_date}
    user_id {1}
  end
end