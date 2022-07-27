
User.create!(
  id: 1,
  name: 'test',
  email: 'test@gmail.com',
  password: 'password',
  admin: true
)

User.create!(
  id: 2,
  name: 'test2',
  email: 'test2@gmail.com',
  password: 'password'
)

Constant.create!(
  key: 'maintenance_mode',
  value: false
)

if Rails.env.development?
  30.times do |n|
    name = "test-#{n+1}"
    description = "test-description-#{n+1}"
    priority = rand(1..3)
    status = rand(1..3)
    limit = "2022-#{rand(1..12)}-#{rand(1..28)}".to_date
    user_id = rand(1..2)
    Task.create!(
      name: name,
      description: description,
      priority: priority,
      status: status,
      limit: limit,
      user_id: user_id
    )
  end
end
