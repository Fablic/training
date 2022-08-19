class Task < ApplicationRecord
  enum status: { not_started: 1, in_progress: 2, completed: 3 }
  enum priority: { low: 1, middle: 2, high: 3 }
end
