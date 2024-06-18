class Label < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  validates :name, presence: true, uniqueness: true, length: { maximum: 25 }
end
