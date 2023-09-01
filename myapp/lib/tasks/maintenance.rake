# lib/tasks/maintenance.rake
namespace :maintenance do
  desc 'Enable maintenance mode'
  task :start do
    puts 'Enabling maintenance mode...'
    set_maintenance_mode(true)
    puts 'Maintenance mode is now enabled.'
  end

  desc 'Disable maintenance mode'
  task :end do
    puts 'Disabling maintenance mode...'
    set_maintenance_mode(false)
    puts 'Maintenance mode is now disabled.'
  end

  private

  def set_maintenance_mode(enabled)
    Rails.application.config.maintenance_mode = enabled
  end
end
