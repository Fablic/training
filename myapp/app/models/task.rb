class Task < ApplicationRecord
    enum priority: { row: 0, middle: 1, high: 2 }
    enum status: { not_started: 0, on_progress: 1, done: 2 }
end
