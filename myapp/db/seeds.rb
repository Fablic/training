# frozen_string_literal: true

3.times do |i|
  User.create(
    name: "user#{i}",
    email: "user#{i}@example.com",
    password: 'password',
  )
end

%w[work private others].each do |l|
  Label.create!(name: l)
end
