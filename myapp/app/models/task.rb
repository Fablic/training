class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 } 
  validates :description, length: { maximum: 255 }
  validates :due_date, presence: true, date: true
  # validates :due_date_check?
end

# def due_date_check
#   errors.add(:due_date, "は現在日時よりも遅い日時を入力してください") if self.due_date < self.created_at
#   print(self.due_date)
#   print(self.created_at)
# end
