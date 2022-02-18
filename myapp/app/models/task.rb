class Task < ApplicationRecord
  enum priority: {high: 1, middle: 2, low: 3}
  enum status: {'未着手' => 1, '着手' => 2, '完了' => 3}

  validates :user_id, :title, :body, :deadline, :priority, :status, presence: true
end