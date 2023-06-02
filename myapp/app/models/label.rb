class Label < ApplicationRecord
  has_many :labellings, dependent: :destroy
  has_many :tasks, through: :labellings

  validates :name, uniqueness: true, presence: true
end
