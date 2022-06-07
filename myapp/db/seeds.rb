5.times do |n|
  User.create!(
    name: "test#{n + 1}",
    email: "test#{n + 1}@example.com",
    password: 'password'
  )
end

3.times do |n|
  Label.create!(
    name: "label#{n + 1}"
  )
end
