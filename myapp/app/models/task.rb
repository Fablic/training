class Task < ApplicationRecord
  enum priority: { high: 1, middle: 2, low: 3 }
  enum status: { '未着手' => 1, '着手' => 2, '完了' => 3 }

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true
  validates :deadline, presence: true
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }

  validate :deadline_before_today

  def self.search( search_word, search_status )
    where = 'deleted = ?'
    values = [ false ]
    unless search_word.empty?
      where.concat( ' AND title LIKE ?' )
      values.push( "%#{search_word}%" ) 
    end
    if Task.statuses.has_value?(search_status.to_i)
      where.concat( ' AND status = ?' )
      values.push( search_status )
    end
    @taskList = Task.where( where, *values )
  end

  private

  def deadline_before_today
    return if deadline.blank?
    errors.add(:deadline, "は今日以降を選択してください") if deadline < Date.today
  end

end
