# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

user = User.create(name: 'Rakuten Taro', email: 'rakuten.taro@rakuten.com')
[*1..5].each do |n|
  user.craete(:task, title: "Task #{n}")
end

