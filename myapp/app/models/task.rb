class Task < ApplicationRecord
  EDITABLE_FIELDS = [:title, :status_id, :due_date, :contents, :priority_id]

  belongs_to :priority
  belongs_to :board
  belongs_to :status
  has_many :tags_task
  has_many :tag, through: :tags_task

  def self.apiInclude()
    return {
      priority: {
        only: [:id, :title, :color]
      },
      status: {
        only: [:id, :title]
      },
      tag: {
        only: [:tag]
      }
    }

  end  

  def due_date
    attributes['due_date'].strftime("%Y/%m/%d %H:%M")
  end  

end
