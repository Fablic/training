# config: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# user
User.create(name: '管理者',role_id: 1 )

# task一覧表示確認用：サンプルデータ
20.times do | n |
  Task.create(name:"サンプル#{ n }" , user_id:1 )
end
