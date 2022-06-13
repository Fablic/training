# Creating normal user
user = User.create!(name: 'normal', email: 'normal@gmail.com' ,password: 'passwordNormal', password_confirmation: 'passwordNormal', admin_flg: 0)

# Creating admin user
User.create!(name: 'admin', email: 'admin@gmail.com' ,password: 'passwordAdmin', password_confirmation: 'passwordAdmin', admin_flg: 1)

# Creating Task
task = user.tasks.create!(title: 'sample task', due_date: '2022-05-01', status: 0)

# Creating Label
label = user.labels.create!(name: 'sample label')

# Creating task_labels
task.labels << label
