class Batch::Maintenance
  def self.start
    maintenance = Maintenance.find(1)

    if maintenance.status.zero?
      maintenance.status = 1
      maintenance.save

      puts '--- Maintenance Starting ---'
      puts '- Acquiring Data -'
      task_count = Task.count.to_s
      user_count = User.count.to_s
      puts '- Data Acquired -'
      puts 'Tasks Count：' + task_count
      puts 'User Count：' + user_count

    else
      puts 'Under Maintenance!!'
    end
  end

  def self.end
    maintenance = Maintenance.find(1)
    if maintenance.status.zero?
      puts 'Maintenance Mode is already ended'
    else
      maintenance.status = 0
      maintenance.save
      puts '--- Turned Maintenance Mode OFF ---'
    end
  end
end