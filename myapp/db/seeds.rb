UserLoginManager.delete_all
UserProject.delete_all
TaskLabel.delete_all
Label.delete_all
Task.delete_all
Group.delete_all
User.delete_all
Project.delete_all

husband = User.new(nickname: 'husband', email: 'husband@treasuremap.com', password: 'husband')
husband.save
friend_1 = User.new(nickname: 'friend_1', email: 'friend_1@treasuremap.com', password: 'friend_1')
friend_1.save

project_marry = Project.new(name: 'Marry')
project_marry.create!

project_friends = Project.new(name: 'Friends')
project_friends.create!

project_private = Project.new(name: 'Husband Private')
project_private.create!

UserProject.new(user: husband, project: project_marry).save
UserProject.new(user: friend_1, project: project_marry).save
UserProject.new(user: husband, project: project_private).save
UserProject.new(user: friend_1, project: project_friends).save

Task.new(
  name: 'Practice to play Guitar',
  priority: 'high',
  end_period_at: Date.new(2020, 10, 31),
  creator_name: husband.nickname,
  assignee_name: husband.nickname,
  description: 'Wherever you are of One ok rock',
  group: project_private.groups.second
).save

Task.new(
  name: 'Prepare wedding ring',
  priority: 'middle',
  end_period_at: Date.new(2020, 10, 31),
  creator_name: husband.nickname,
  assignee_name: husband.nickname,
  description: 'Checking Ring size of girlfrined',
  group: project_private.groups.first
).save

Task.new(
  name: 'Practice to Sing for wedding',
  priority: 'high',
  end_period_at: Date.new(2020, 9, 30),
  creator_name: friend_1.nickname,
  assignee_name: friend_1.nickname,
  description: 'sweet song',
  group: project_friends.groups.first
).save

Task.new(
  name: 'Dating girl friend',
  priority: 'high',
  end_period_at: Date.current,
  creator_name: husband.nickname,
  assignee_name: husband.nickname,
  description: 'She is name Chie',
  group: project_marry.groups.last
).save

Task.new(
  name: 'Introduce my girl friend to my people',
  priority: 'high',
  end_period_at: Date.new(2019, 12, 14),
  creator_name: husband.nickname,
  assignee_name: husband.nickname,
  description: 'Korean friends, japanese friends, my parents',
  group: project_marry.groups.third
).save

Task.new(
  name: 'Rental some room',
  priority: 'low',
  end_period_at: Date.new(2020, 9, 30),
  creator_name: husband.nickname,
  assignee_name: friend_1.nickname,
  description: 'Ready boolean, music, etc',
  group: project_marry.groups.first
).save

Task.new(
  name: 'Buy flower',
  priority: 'high',
  end_period_at: Date.new(2020, 9, 30),
  creator_name: husband.nickname,
  assignee_name: husband.nickname,
  description: 'Rose',
  group: project_marry.groups.first
).save
