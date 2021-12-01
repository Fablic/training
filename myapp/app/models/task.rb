class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1024 }
  validates :deadline, presence: true
  validate  :since_now

  private

  def since_now
    errors.add(:deadline, 'は、未来日時を登録して下さい') if !deadline.nil? && (deadline <= DateTime.now)
  end
end
