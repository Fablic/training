# frozen_string_literal: true

# some comments for label model
class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
  belongs_to :user

  validates :name, presence: true, length: { maximum: 255 }

  scope :get_own_labels, -> (user_id) { where(user_id: user_id) if user_id.present? }
end
