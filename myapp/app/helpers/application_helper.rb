module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'タスク管理'
    if page_title.empty?
      base_title
    else
      page_title + '  |  ' + base_title
    end
  end
end
