# == Schema Information
#
# Table name: users
#
#  id              :integer          unsigned, not null, primary key
#  email           :string(255)      not null
#  is_admin        :boolean          default(FALSE), not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password_digest { "MySPassWord" }
    is_admin { false }
  end
end
