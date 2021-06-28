class MasterTaskPriority < ApplicationRecord
    LOW = 1
    MIDDLE = 2
    HIGH = 3
    has_many :tasks
end
