class Task < ApplicationRecord
    # タスクステータス
    enum task_status_id: { 未着手: 0, 着手: 1, 完了: 2 }

    # タスク種別  
    enum task_type_id: { 通常業務: 1, 通常業務外: 2, プライベート: 3, その他: 4 }
end
