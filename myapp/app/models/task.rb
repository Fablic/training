class Task < ApplicationRecord
  enum status: { not_started: 1, in_progress: 2, completed: 3 }
  enum priority: { low: 1, middle: 2, high: 3 }

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :detail, presence: true
  validates :detail, length: { maximum: 100 }

  def self.search(name, status)
    # Task.where(status: "%#{status}%"). where(['name like?', "%#{name}%"]) if name.present?
    sql = ''
    sql += " name like '%#{name}%' " if name.present?
    sql += ' AND ' if sql.present? && status.present?
    sql += " status = '#{status}' " if status.present?

    Task.where(sql)
  end
end
