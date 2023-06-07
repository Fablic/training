class Tasks::Batch::Maintenance
  def self.start
    mainte = Maintenance.find(1)

    if mainte.status.zero?
      mainte.status = 1
      mainte.save
      puts I18n.t('maintenance.messages.start_maintenance')

    else
      puts I18n.t('maintenance.messages.already_maintained')
    end
  end

  def self.end
    mainte = Maintenance.find(1)

    if mainte.status.zero?
      puts I18n.t('maintenance.messages.completed_maintenance')
    else
      mainte.status = 0
      mainte.save
      puts I18n.t('maintenance.messages.finished_maintenance')
    end
  end
end
