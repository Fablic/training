class TaskLabelAttachment < ApplicationRecord
  belongs_to :task
  belongs_to :label

  validates :label_id, uniqueness: { scope: :task_id }
  validate :check_ownership

  private

  def check_ownership
    errors.add(:base, :invalid_ownership) unless task.user_id == label.user_id
  end
end
