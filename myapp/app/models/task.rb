class Task < ApplicationRecord
  belongs_to :user

  enum priority: { high: 1, middle: 2, low: 3 }
  enum status: { '未着手' => 1, '着手' => 2, '完了' => 3 }

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true
  validates :deadline, presence: true
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }

  validate :deadline_before_today

  def self.search( user_id, search_word, search_status, search_labels, page)
    where = 'user_id = ? AND deleted = ?'
    values = [ user_id, false ]
    unless search_word.blank?
      where.concat( ' AND title LIKE ?' )
      values.push( "%#{search_word}%" ) 
    end
    if Task.statuses.has_value?(search_status.to_i)
      where.concat( ' AND status = ?' )
      values.push( search_status )
    end
    unless search_labels.blank?
      labels = []
      search_labels.keys.each do |lid|
        labels.push( ' FIND_IN_SET(?, label_id)' )
        values.push( lid )
      end
      where.concat( ' AND' + labels.join(' OR') )
    end
    Task.where( where, *values).page(page).per(10)
  end

  private

  def deadline_before_today
    return if deadline.blank?
    errors.add(:deadline, "は今日以降を選択してください") if deadline < Date.today
  end

end
