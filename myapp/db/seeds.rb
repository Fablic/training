ActiveRecord::Base.transaction do
  user = User.create!(name: 'taro', email: 'taro2@hoge.hoge', password: 'password', password_confirmation: 'password')
  user.tasks.create!(name: 'sample_task')
end
