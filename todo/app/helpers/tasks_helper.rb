# frozen_string_literal: true

module TasksHelper
  def status_text
    { todo: '未着手', doing: '着手', done: '完了' }.with_indifferent_access
  end
end
