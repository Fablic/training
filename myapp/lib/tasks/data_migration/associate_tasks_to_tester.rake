namespace :data_migration do
  task :associate_tasks_to_tester => :environment do
    # NOTE: tester is defined in db/seeds.rb
    Task.where(user_id: nil).each do |task|
      task.update!(user: User.find_by!(name: 'tester'))
    end
  end
end
