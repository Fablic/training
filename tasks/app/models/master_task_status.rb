class MasterTaskStatus < ApplicationRecord
    NOT_STARTED = 1
    has_many :tasks
end
