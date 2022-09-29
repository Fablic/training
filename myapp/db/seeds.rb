# frozen_string_literal: true

require 'securerandom'

5.times do |n|
  User.create!(
    name: "くま太郎#{n + 1}",
    email: "kuma#{n + 1}@gmail.com",
    password_digest: SecureRandom.alphanumeric
  )
end
