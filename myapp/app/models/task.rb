class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1024 }
  validates :deadline, presence: true
  validate  :since_now

  enum status: { not_started: 0, in_progress: 1, done: 2 }

  private
    def since_now
      unless deadline == nil
        errors.add(:deadline, 'は、未来日時を登録して下さい') if deadline <= DateTime.now
      end
    end
end
