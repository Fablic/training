module TaskHelper
  # Convert Status → StatusView
  def status_view(code)
    Task::STATUS_VIEW.each_key do |key|
      return Task::STATUS_VIEW[key] if Task.statuses[code] == key
    end

    ''
  end
end
