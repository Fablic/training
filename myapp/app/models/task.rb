class Task < ApplicationRecord

# enum priority:    { priority_1: 0, priority_2: 1, priority_3: 2 }
# enum status:      { not_started: 0, start: 1, completed: 2 }
validates :title, presence: true

end
