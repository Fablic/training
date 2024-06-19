namespace :maintenance do 
  desc 'Create a tmp file to start maintenance'
  task start: :environment do 
    FileUtils.touch(Rails.root.join('tmp', 'maintenance_tmp.txt'))
    Rails.logger.info 'Tmp file Created.'
  end

  desc 'Delete the tmp file to end maintenance'
  task end: :environment do 
    FileUtils.rm_f(Rails.root.join('tmp', 'maintenance_tmp.txt'))
    Rails.logger.info 'Tmp file deleted.'
  end
end
