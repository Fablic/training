class Task < ApplicationRecord
    with_options presence: true do
        validates :title
        validates :description
        validates :termination_at
        validates :priority
        validates :status
    end
    validates :title, length: { maximum: 50 }
    validates :description, length: { maximum: 255 }
    validate :termination_at_must_be_greater_than_current_at

    enum priority: { low: 0, middle: 1, high: 2 }
    enum status: { not_started: 0, on_progress: 1, done: 2 }

    private
    
    def termination_at_must_be_greater_than_current_at
        return if termination_at.blank? || termination_at > Time.now
        
        errors.add(:termination_at, :termination_at_must_be_greater_than_current_at)
    end
end
