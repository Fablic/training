class Task < ApplicationRecord
    # todo enumを利用する
    STATUS = ['未着手', '着手', '完了']
    URGENCY = ['特に決まってない', '空いた時間にやる', 'いつものペースでやる', '急いで終わらせる', '何よりも早く終わらせる']
    IMPORTANCE = ['いつか忘れる', '誰かやってくれる', '誰かが困る', '結構怒られる', '地獄が待ってる']
end
