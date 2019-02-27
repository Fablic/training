# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :delete_all
  has_many :tasks, through: :task_labels

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: { scope: :name } # user_idとnameの組み合わせが一意であること
end
