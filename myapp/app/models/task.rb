class Task < ApplicationRecord
  # 未着手 着手 完了
  enum status: {not_started: 1, start: 2, done: 3}
  # 特に決まってない 空いた時間にやる いつものペースでやる 急いで終わらせる 何よりも早く終わらせる
  enum urgency: {not_decided: 1, spare_time: 2, usual_pace: 3, hurry: 4, asap: 5}
  # いつか忘れる 誰かやってくれる 誰かが困る 結構怒られる 何よりも重要
  enum importance: {very_low: 1, low: 2, normal: 3, high: 4, very_high: 5}

  PRIORITY_COEF = 4

  def cal_priority_point
    point = Task.urgencies[urgency] * Task.importances[importance] * PRIORITY_COEF
    date_diff = Date.new(deadline.strftime('%Y').to_i, deadline.strftime('%m').to_i, deadline.strftime('%e').to_i) - Date.today

    priority_point = point - date_diff
    if priority_point < 0 then
        return 0
    else
        return priority_point
    end
  end
end
