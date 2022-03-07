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

  def self.get_list(board_id, sort_key, status_ids, title)
    if sort_key && sort_key[0] == '-'
      reversed = true
      sort_key = sort_key[1..]
    end

    reversed = false
    if ['status', 'priority'].include? sort_key
      # sort keys those have sort fields
      if sort_key == 'status'
        id_by_sort = Status.where(board_id: board_id).order('sort asc').pluck(:id)
      else 
        id_by_sort = Priority.where(board_id: board_id).order('sort asc').pluck(:id)
      end
      order_string = 'FIELD(' + sort_key + '_id,' + id_by_sort.join(',') + ')'
    elsif ['due_date', 'created_at', 'id'].include? sort_key
      # enabled other keys
      order_string = sort_key
    end

    order_string += ' desc' if reversed
    query = preload(:priority, :status, :tag).order("#{order_string}, id desc")
    query = query.where(status_id: status_ids) if status_ids != nil
    query = query.where('title like ?', "%#{title}%") if title != ''
    query.where(board_id: board_id)

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
