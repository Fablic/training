class Task < ApplicationRecord
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

  validates :title, {presence: true, length: { maximum: 45 }}
  validates :body, {presence: true, length: { maximum: 255 }}
  validates :status, {presence: true, inclusion: { in: Task.statuses.keys }}
  validates :urgency, {presence: true, inclusion: { in: Task.urgencies.keys }}
  validates :importance, {presence: true, inclusion: { in: Task.importances.keys }}
  validates :deadline, presence: true, Deadline: true

  def get_priority_point
    level = search_apply_level()
    case level
    when 1
      cal_priority_point(FIRST_LEVEL_BASE_POINT, 4, 3)
    when 2
      cal_priority_point(SECOUND_LEVEL_BASE_POINT, 6, 5)
    when 3
      cal_priority_point(THIRD_LEVEL_BASE_POINT, 6, 5)
    when 4
      cal_priority_point(FOURTH_LEVEL_BASE_POINT, 8, 7)
    end
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
    if date_diff == 0
      day_point = 5
    elsif date_diff <= 3
      day_point = 4
    elsif date_diff <= 7
      day_point = 3
    elsif date_diff <= 14
      day_point = 2
    elsif date_diff <= 30
      day_point = 1
    else
      day_point = 0
    end

    total = Task.importances[importance] + Task.urgencies[urgency]
    if total === first_comparison_value
      base_point + day_point - 5
    elsif total === secound_comparison_value
      base_point + day_point - 10
    else
      base_point + day_point - 20
    end
  end
end
