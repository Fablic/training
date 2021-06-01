module TasksHelper
  def translate_priority(priority)
    case priority
    when 'low'
      t('activerecord.enum.task.priority.low')
    when 'normal'
      t('activerecord.enum.task.priority.normal')
    when 'high'
      t('activerecord.enum.task.priority.high')
    else
      raise "Unexpected priority `#{priority}` is set."
    end
  end

  def translate_status(status)
    case status
    when 'waiting'
      t('activerecord.enum.task.status.waiting')
    when 'doing'
      t('activerecord.enum.task.status.doing')
    when 'done'
      t('activerecord.enum.task.status.done')
    else
      raise "Unexpected status `#{status}` is set."
    end
  end
end
