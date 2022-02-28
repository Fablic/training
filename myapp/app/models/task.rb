class Task < ApplicationRecord
  EDITABLE_FIELDS = %i[title status_id due_date contents priority_id]
  validates_associated :priority, :board, :status
  validates :title, presence: true
  validates :contents, presence: true
  validate :valid_step_change, on: :update

  belongs_to :priority
  belongs_to :board
  belongs_to :status
  has_many :tags_task
  has_many :tag, through: :tags_task

  def valid_step_change
    return if status_id_was == status_id

    available_next_step = Status.find(status_id_was).to_status
    
    for next_step in available_next_step do
      return if status == next_step
    end

    errors.add(:status, 'cannot change to ' + status.title)
  end

  def self.apiInclude
    {
      priority: {
        only: %i[id title color sort]
      },
      status: {
        only: %i[id title sort]
      },
      tag: {
        only: [:tag]
      }
    }
  end

  def due_date
    attributes['due_date'].strftime('%Y/%m/%d %H:%M')
  end
end
