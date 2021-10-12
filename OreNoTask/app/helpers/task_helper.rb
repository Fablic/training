# frozen_string_literal: true

module TaskHelper
  def renderStatus(status)
    case status
      when 'not_started' then
        I18n.t('dictionary.words.status_not_started')
      when 'wip' then
        I18n.t('dictionary.words.status_wip')
      when 'completed' then
        I18n.t('dictionary.words.status_completed')
      else
      	'undefined'
    end
  end
end
