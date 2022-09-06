class Task < ApplicationRecord

  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }

    # ステータスEnum
    enum status: {
      not_started: '0',
      in_progress: '1',
      closed: '2',
    }

    def self.search(word, status)
      return Task.all.order('tasks.created_at desc') if word.blank? && status.blank?

      sql = ''
      sql += " title like '%#{word}%' " if word.present?
      sql += ' AND ' if sql.present? && status.present?
      sql += " status = '#{status}' " if status.present?

      Task.where(sql).order('tasks.created_at desc')
    end
  end
