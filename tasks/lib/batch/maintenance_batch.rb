class Batch::MaintenanceBatch
  def self.maintenance_start_batch
    if Mode.maintenance_start
      puts 'Success maintenance mode start'
    else
      puts 'Failure maintenance mode start'
    end
  end

  def self.maintenance_end_batch
    if Mode.maintenance_end
      puts 'Success maintenance mode end'
    else
      puts 'Failure maintenance mode end'
    end
  end
end
