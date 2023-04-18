FactoryBot.define do
  factory :label do
    sequence(:name) { |i| "label_name_#{i}" }
  end
end
