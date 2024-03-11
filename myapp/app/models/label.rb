class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  validates :name, presence: true, length: { maximum: 255 }

  scope :get_own_labels, -> (user_id) { where(user_id: user_id) if user_id.present? }
end
