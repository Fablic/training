module ApplicationHelper
  def page_title(page_title = '')
    if page_title.empty?
      I18n.t('title.base')
    else
      "#{page_title} | #{I18n.t('title.base')}"
    end
  end
end
