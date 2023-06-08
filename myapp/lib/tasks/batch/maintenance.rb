class Tasks::Batch::Maintenance
  def self.start
    mainte = Maintenance.find_by(status: 0)

    if mainte.nil?
      p I18n.t('maintenance.messages.already_maintained')
    else
      mainte.update(status: 1)
      p I18n.t('maintenance.messages.start_maintenance')
    end
  end

  def self.end
    mainte = Maintenance.find_by(status: 1)

    if mainte.nil?
      puts I18n.t('maintenance.messages.completed_maintenance')
    else
      mainte.update(status: 0)
      p I18n.t('maintenance.messages.finished_maintenance')
    end
  end
end
