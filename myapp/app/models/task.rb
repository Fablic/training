# frozen_string_literal: true

class Task < ApplicationRecord
  # user対応コメントアウト
  # # 結合キー
  # belongs_to :user

  # バリデーション
  validates :title, length: { minimum: 1, maximum: 128 }
  validates :content, length: { minimum: 1, maximum: 1024 }
  validates :label, length: { minimum: 1, maximum: 64 }

  # ステータスEnum
  enum status: {
    not_started: '1',
    in_progress: '2',
    closed: '3',
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
