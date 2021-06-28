class MasterTaskStatus < ApplicationRecord
    NOT_STARTED = 1
    STARTED = 2
    FINISHED = 3
    has_many :tasks
end
