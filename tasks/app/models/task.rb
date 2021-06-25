class Task < ApplicationRecord
    belongs_to :priority, class_name: "MasterTaskPriority"
    belongs_to :status, class_name: "MasterTaskStatus"
    scope :getAll, -> { where(deleted_at: nil) }
end
