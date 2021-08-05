# frozen_string_literal: true

json.tasks @tasks, partial: 'tasks/task', as: :task

json.meta do |m|
  m.totalPages @tasks.total_pages
  m.currentPage @tasks.current_page
end
