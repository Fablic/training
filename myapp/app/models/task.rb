class Task < ApplicationRecord
  # 未着手 着手 完了
  enum status: {not_started: 1, start: 2, done: 3}
  # 空いた時間にやる いつものペースでやる 急いで終わらせる 何よりも早く終わらせる
  enum urgency: {spare_time: 1, usual_pace: 2, hurry: 3, asap: 4}
  # いつか忘れる 誰かが困る 結構怒られる 何よりも重要
  enum importance: {low: 1, normal: 2, high: 3, very_high: 4}

  FIRST_LEVEL   = 1
  SECOUND_LEVEL = 2
  THIRD_LEVEL   = 3
  FOURTH_LEVEL  = 4

  FIRST_LEVEL_BASE_POINT   = 100
  SECOUND_LEVEL_BASE_POINT = 80
  THIRD_LEVEL_BASE_POINT   = 50
  FOURTH_LEVEL_BASE_POINT  = 20

  BASE_POINT_MAPPING_HASH = {
    FIRST_LEVEL   => FIRST_LEVEL_BASE_POINT,
    SECOUND_LEVEL => SECOUND_LEVEL_BASE_POINT,
    THIRD_LEVEL   => THIRD_LEVEL_BASE_POINT,
    FOURTH_LEVEL  => FOURTH_LEVEL_BASE_POINT
  }

  validates :title, {presence: true, length: { maximum: 45 }}
  validates :body, {presence: true, length: { maximum: 255 }}
  validates :status, {presence: true, inclusion: { in: Task.statuses.keys }}
  validates :urgency, {presence: true, inclusion: { in: Task.urgencies.keys }}
  validates :importance, {presence: true, inclusion: { in: Task.importances.keys }}
  validates :deadline, presence: true, Deadline: true

  def get_priority_point
    level = search_apply_level()
    cal_priority_point(level)
  end

  def search_apply_level
    if Task.importances[importance] >= 3 && Task.urgencies[urgency] >= 3
      FIRST_LEVEL
    elsif Task.importances[importance] <= 2 && Task.urgencies[urgency] <= 2
      FOURTH_LEVEL
    elsif Task.importances[importance] >  Task.urgencies[urgency]
      SECOUND_LEVEL
    else
      THIRD_LEVEL
    end
  end

  def self.search(keyword = '', status = '')
    where(["title like? AND status like?", "%#{keyword}%", "%#{status}%"])
  end

  def self.board_bata_create()
    data = []
    for level in 1..4 do
      items = get_bord_item_data_by_priority_level(level)
      data << set_board_data(level, items)
    end
    data
  end

  private

  def cal_priority_point(level)
    date_diff = Date.new(deadline.strftime('%Y').to_i, deadline.strftime('%m').to_i, deadline.strftime('%e').to_i) - Date.today

    day_point = 0
    {0 => 5, 3 => 4, 7 => 3, 14 => 2, 30 => 1}.each { |k, v|
      if date_diff <= k
        day_point = v
        break
      end
    }

    # レベル毎に比較する値
    comparison_hash = {
      FIRST_LEVEL   => [8, 7],
      SECOUND_LEVEL => [6, 5],
      THIRD_LEVEL   => [6, 5],
      FOURTH_LEVEL  => [4, 3]
    }
    total = Task.importances[importance] + Task.urgencies[urgency]
    if total === comparison_hash[level][0]
      BASE_POINT_MAPPING_HASH[level] + day_point - 5
    elsif total === comparison_hash[level][1]
      BASE_POINT_MAPPING_HASH[level] + day_point - 10
    else
      BASE_POINT_MAPPING_HASH[level] + day_point - 20
    end
  end

  def self.get_bord_item_data_by_priority_level(level)
    case level
    when FOURTH_LEVEL
      from = 0
      to = FOURTH_LEVEL_BASE_POINT - 1
    when THIRD_LEVEL
      from = FOURTH_LEVEL_BASE_POINT
      to = THIRD_LEVEL_BASE_POINT - 1
    when SECOUND_LEVEL
      from = THIRD_LEVEL_BASE_POINT
      to = SECOUND_LEVEL_BASE_POINT - 1
    when FIRST_LEVEL
      from = SECOUND_LEVEL_BASE_POINT
      to = FIRST_LEVEL_BASE_POINT - 1
    end
    where(priority_point: from..to).order(priority_point: "DESC")
  end

  def self.set_board_data(level, items)
    itemData = []
    items.each do |item|
      itemData << {
        title: "##{item.id.to_s} #{item.title}",
        status: item.status,
        taskId: item.id
      }
    end

    {
      title: "第" + level.to_s + "優先グループ",
      class: "task_group_" + level.to_s,
      item: itemData
    }
  end
end
