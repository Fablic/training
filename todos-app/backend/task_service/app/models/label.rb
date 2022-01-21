# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :task_label_links, dependent: :destroy
  has_many :tasks, through: :task_label_links

  validates :user_id, presence: true, uniqueness: { scope: :name }
  validates :name, length: { maximum: 15 }, format: { without: /\s/ }, allow_nil: false, presence: true
end
