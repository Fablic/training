3.times do |i|
  User.create(
    name: "user#{i}",
    email: "user#{i}@example.com",
    password: 'password',
  )
end
