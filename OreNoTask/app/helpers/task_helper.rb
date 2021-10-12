# frozen_string_literal: true

module TaskHelper
  def renderStatus(status)
    case status
      when 'not_started' then
        I18n.t('enumerize.task.status.not_started')
      when 'wip' then
        I18n.t('enumerize.task.status.wip')
      when 'completed' then
        I18n.t('enumerize.task.status.completed')
      else
      	'undefined'
    end
  end
end
