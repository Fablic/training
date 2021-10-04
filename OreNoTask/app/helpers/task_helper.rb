# frozen_string_literal: true

module TaskHelper
  def renderStatus(status)
    case status
      when 0 then
        I18n.t('dictionary.words.status_not_started')
      when 1 then
        I18n.t('dictionary.words.status_wip')
      when 2 then
        I18n.t('dictionary.words.status_completed')
      else
      	'undefined'
    end
  end
end
