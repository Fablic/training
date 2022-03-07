# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = {
  'admin': {
    'email': 'admin@example.com',
    'permissions': User::PERM_LOGIN + User::PERM_ADMIN
  },
  'user_a': {
    'email': 'user_a@example.com',
    'permissions': User::PERM_LOGIN
  },
  'user_b': {
    'email': 'user_b@example.com',
    'permissions': User::PERM_LOGIN
  }
}

users.each do |_key, user|
  # create users
  user[:user] = User.create(
    email: user[:email],
    permissions: user[:permissions],
    password: User.create_hash('test'),
    created_at: Time.now,
    updated_at: Time.now
  )

  # create board for each users
  user[:board] = Board.create(
    id: user[:user].id,
    title: "board for user #{user[:email]}",
    created_at: Time.now,
    updated_at: Time.now
  )

  # link user and board
  BoardsUser.create(
    board_id: user[:board].id,
    user_id: user[:user].id,
    permissions: BoardsUser::PERM_READ + BoardsUser::PERM_WRITE + BoardsUser::PERM_ADMIN,
    created_at: Time.now,
    updated_at: Time.now
  )

  # create default priorities for each boards
  Priority.create(
    [
      { title: 'Critical', sort: 1, color: 'ff0000', board_id: user[:board].id, created_at: Time.now,
        updated_at: Time.now },
      { title: 'Major', sort: 2, color: 'ffff00', board_id: user[:board].id, created_at: Time.now,
        updated_at: Time.now },
      { title: 'Minor', sort: 3, color: '00ff00', board_id: user[:board].id, created_at: Time.now,
        updated_at: Time.now }
    ]
  )

  # create default statuses for each boards
  status1 = Status.create(
    { title: 'Not Started', sort: 1, board_id: user[:board].id, created_at: Time.now,
      updated_at: Time.now }
  )
  status2 = Status.create(
    { title: 'In Progress', sort: 2, board_id: user[:board].id, created_at: Time.now,
      updated_at: Time.now }
  )
  status3 = Status.create(
    { title: 'Closed', sort: 3, board_id: user[:board].id, created_at: Time.now, updated_at: Time.now }
  )

  # link statuses
  StatusStep.create(
    [
      { from_status_id: status2.id, to_status_id: status1.id, created_at: Time.now, updated_at: Time.now },
      { from_status_id: status1.id, to_status_id: status3.id, created_at: Time.now, updated_at: Time.now },
      { from_status_id: status1.id, to_status_id: status2.id, created_at: Time.now, updated_at: Time.now },
      { from_status_id: status3.id, to_status_id: status1.id, created_at: Time.now, updated_at: Time.now }
    ]
  )
end

# for additinal user, user_a can read+write admin user's board
BoardsUser.create(
  board_id: users[:admin][:board].id,
  user_id: users[:user_a][:user].id,
  permissions: BoardsUser::PERM_READ + BoardsUser::PERM_WRITE,
  created_at: Time.now,
  updated_at: Time.now
)

# for additinal user, user_b can see admin user's board
BoardsUser.create(
  board_id: users[:admin][:board].id,
  user_id: users[:user_b][:user].id,
  permissions: BoardsUser::PERM_READ,
  created_at: Time.now,
  updated_at: Time.now
)
