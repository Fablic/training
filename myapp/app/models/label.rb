class Label < ApplicationRecord
  has_many :labellings, dependent: :destroy
  has_many :tasks, through: :labellings

  validates :name, uniqueness: true, presence: true

  scope :where_label, -> (label) { where(name: label) if label.present? }
end
