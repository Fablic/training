class Label < ApplicationRecord
  has_many :tasks_labels
  enum color: {gray: 1, blue: 2, green: 3, red: 4, purple: 5}

  def self.findByUserId(userId)
    return where(user_id: userId)
  end
end
