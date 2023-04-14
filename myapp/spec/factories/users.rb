# == Schema Information
#
# Table name: users
#
#  id                                :bigint           not null, primary key
#  deleted_at                        :datetime
#  email                             :string(255)      not null
#  name                              :string(255)      not null
#  password_digest                   :string(255)      not null
#  role({0: "ordinary", 1: "admin"}) :integer          default(0), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name)
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "name_#{i}" }
    password { '12345678' }
    sequence(:email) { |i| "takasawa#{i}@rakuten.com" }
    role { %w[ordinary admin].sample }
  end
end
