class Task < ApplicationRecord
    belongs_to :priority, class_name: "MasterTaskPriority"
    belongs_to :status, class_name: "MasterTaskStatus"
    scope :without_deleted, -> { where(deleted_at: nil) }
end
