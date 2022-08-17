FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    detail { 'RSpecを書く' }
    status { 1 }
    priority { 1 }
  end
end