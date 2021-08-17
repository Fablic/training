FactoryBot.define do
  factory :mode, class: Mode do
    mode_name { 'maintenance' }
    value { false }
  end
end
