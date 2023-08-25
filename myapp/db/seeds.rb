
# Delete all existing users
User.delete_all

# Create the initial user
user = User.create!(
  username: 'sample_user',
  email: 'sample@example.com',
  password: 'password',
  role: 'admin' # or 'user' depending on your roles
)

puts "Initial user created:"
puts "Username: #{user.username}"
puts "Email: #{user.email}"
