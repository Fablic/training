# == Schema Information
#
# Table name: tags
#
#  id         :integer          unsigned, not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tag do
    name { Faker::Hobby.unique.activity }
  end
end
