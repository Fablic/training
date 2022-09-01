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
    order = 'tasks.created_at desc';

    return Task.all.order(order) if word.blank? && status.blank?
    return Task.where('title like ?', "%#{word}%").order(order) if !word.blank? && status.blank?
    return Task.where(status: status).order(order) if word.blank? && !status.blank?
    return Task.where('title like ?', "%#{word}%").where(status: status).order(order) if !word.blank? && !status.blank?
  end

end
