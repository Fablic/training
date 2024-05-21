# frozen_string_literal: true

class Task < ApplicationRecord
  # validates :title, presence: { message: 'タイトルを入力してください' }, length: { maximum: 255, message: 'タイトルは255文字以内で入力してください' }
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 30000 }
end
