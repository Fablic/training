class Task < ApplicationRecord
  has_many :tasks_labels
  has_many :labels, through: :tasks_labels
  belongs_to :user

  # 未着手 着手 完了
  enum status: {not_started: 1, start: 2, done: 3}
  # 空いた時間にやる いつものペースでやる 急いで終わらせる 何よりも早く終わらせる
  enum urgency: {spare_time: 1, usual_pace: 2, hurry: 3, asap: 4}
  # いつか忘れる 誰かが困る 結構怒られる 何よりも重要
  enum importance: {low: 1, normal: 2, high: 3, very_high: 4}

  FIRST_LEVEL_BASE_POINT   = 20
  SECOUND_LEVEL_BASE_POINT = 50
  THIRD_LEVEL_BASE_POINT   = 80
  FOURTH_LEVEL_BASE_POINT  = 100

  def get_priority_point
    hash = {
      1 => [FIRST_LEVEL_BASE_POINT, 4, 3],
      2 => [SECOUND_LEVEL_BASE_POINT, 6, 5],
      3 => [THIRD_LEVEL_BASE_POINT, 6, 5],
      4 => [FOURTH_LEVEL_BASE_POINT, 8, 7]
    }
    level = search_apply_level()
    cal_priority_point(*hash[level])
  end

  def search_apply_level
    if Task.importances[importance] >= 3 && Task.urgencies[urgency] >= 3
      4
    elsif Task.importances[importance] <= 2 && Task.urgencies[urgency] <= 2
      1
    elsif Task.importances[importance] >  Task.urgencies[urgency]
      3
    else
      2
    end
  end

  def cal_priority_point(base_point, first_comparison_value, secound_comparison_value)
    date_diff = Date.new(deadline.strftime('%Y').to_i, deadline.strftime('%m').to_i, deadline.strftime('%e').to_i) - Date.today

    day_point = 0
    {0 => 5, 3 => 4, 7 => 3, 14 => 2, 30 => 1}.each { |k, v|
      if date_diff <= k
        day_point = v
        break
      end
    }

    total = Task.importances[importance] + Task.urgencies[urgency]
    if total === first_comparison_value
      base_point + day_point - 5
    elsif total === secound_comparison_value
      base_point + day_point - 10
    else
      base_point + day_point - 20
    end
  end

  def self.search(keyword, status, labelId, userId)
    result = left_joins(:tasks_labels).where(["title like? AND status like? AND user_id = ?", "%#{keyword}%", "%#{status}%", userId])
    if labelId.present?
      return result.where(["label_id = ?", labelId])
    end
    return result
  end

  def self.boardDataCreate(usreId)
    data = []
    for level in 1..4 do
      items = getBordItemDataByPriorityLevel(level, usreId)
      data << setBoardData(level, items)
    end
    return data
  end

  def self.findByUserId(userId)
    return where(user_id: userId)
  end

  private

  def self.getBordItemDataByPriorityLevel(level, usreId)
    case level
    when 1
      from = THIRD_LEVEL_BASE_POINT
      to = FOURTH_LEVEL_BASE_POINT - 1
    when 2
      from = SECOUND_LEVEL_BASE_POINT
      to = THIRD_LEVEL_BASE_POINT - 1
    when 3
      from = FIRST_LEVEL_BASE_POINT
      to = SECOUND_LEVEL_BASE_POINT - 1
    when 4
      from = 0
      to = FIRST_LEVEL_BASE_POINT - 1
    end
    return where(priority_point: from..to, user_id: usreId).order(priority_point: "DESC")
  end

  def self.setBoardData(level, items)
    itemData = []
    items.each do |item|
      itemData << {
        title: "##{item.id.to_s} #{item.title}",
        status: item.status,
        taskId: item.id
      }
    end

    return {
      title: "第" + level.to_s + "優先グループ",
      class: "task_group_" + level.to_s,
      item: itemData
    }
  end
end
