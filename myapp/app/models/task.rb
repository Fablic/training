# frozen_string_literal: true

class Task < ApplicationRecord
  # 結合キー
  belongs_to :user
  has_many :labels, dependent: :destroy

  # バリデーション
  validates :title, length: { minimum: 1, maximum: 128 }
  validates :content, length: { minimum: 1, maximum: 1024 }

  # ステータスEnum
  enum status: {
    not_started: '1',
    in_progress: '2',
    closed: '3',
  }

  def self.search(user_id, word, status)
    return Task.eager_load(:labels).all.order('tasks.created_at desc, labels.created_at desc') if user_id.nil? && word.blank? && status.blank?

    sql = ''
    sql += " user_id = #{user_id} " if user_id.present?
    sql += ' AND ' if sql.length > 0 && word.present?
    sql += " title like '%#{word}%' " if word.present?
    sql += ' AND ' if sql.length > 0 && status.present?
    sql += " status = '#{status}' " if status.present?

    Task.eager_load(:labels).where(sql).order('tasks.created_at desc, labels.created_at desc')
  end
end
