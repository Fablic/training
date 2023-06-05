class Label < ApplicationRecord
  belongs_to :user

  has_many :labellings
  has_many :tasks, through: :labellings

  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
