class Label < ApplicationRecord
  belongs_to :user, optional: true
  has_many :labellings, dependent: :destroy
  has_many :tasks, through: :labellings

  validates :name, presence: true
end
