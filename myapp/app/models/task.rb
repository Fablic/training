class Task < ApplicationRecord
  enum status: { untouched: 1, doing: 2, completed: 3 }

  validates :name, presence: true
  validates :name, length: { maximum: 10 }
  validates :description, presence: true
  validates :description, length: { maximum: 50 }

  scope :name_like, -> (name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :status_equal, -> (status) { where('status = ?', status) if status.present? }

end
