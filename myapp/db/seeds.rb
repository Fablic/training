# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

board = Board.create(
  id: 1,
  title: 'board',
  created_at: Time.now,
  updated_at: Time.now
)

Priority.create([
                  { id: 1, title: 'Critical', sort: 1, color: 'ff0000', board_id: board.id, created_at: Time.now,
                    updated_at: Time.now },
                  { id: 2, title: 'Major', sort: 2, color: 'ffff00', board_id: board.id, created_at: Time.now,
                    updated_at: Time.now },
                  { id: 3, title: 'Minor', sort: 3, color: '00ff00', board_id: board.id, created_at: Time.now,
                    updated_at: Time.now }
                ])

Status.create([
                { id: 1, title: 'Not Started', sort: 1, board_id: board.id, created_at: Time.now,
                  updated_at: Time.now },
                { id: 2, title: 'In Progress', sort: 2, board_id: board.id, created_at: Time.now,
                  updated_at: Time.now },
                { id: 3, title: 'Closed', sort: 3, board_id: board.id, created_at: Time.now, updated_at: Time.now }
              ])
StatusStep.create([
                    { id: 1, from_status_id: 2, to_status_id: 1, created_at: Time.now, updated_at: Time.now },
                    { id: 2, from_status_id: 1, to_status_id: 3, created_at: Time.now, updated_at: Time.now },
                    { id: 3, from_status_id: 1, to_status_id: 2, created_at: Time.now, updated_at: Time.now },
                    { id: 4, from_status_id: 3, to_status_id: 1, created_at: Time.now, updated_at: Time.now }
                  ])
