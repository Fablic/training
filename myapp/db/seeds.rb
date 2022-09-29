# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# user = User.new
# user.name = '一真'
# user.save

Task.delete_all
User.delete_all
Label.delete_all
Labelling.delete_all

3.times do |i|
    user = User.create(name: "具志堅一真#{i + 1}", password: "gushiken#{i + 1}", email: "gushiken#{i + 1}@example.com")
    task = Task.create(name: "タスク番号#{i + 1}", description: '動作確認', status: 1, user_id: user.id)
    label = Label.create(name: "ラベル#{i + 1}")
    labelling = Labelling.create(task: task, label: label)
end
