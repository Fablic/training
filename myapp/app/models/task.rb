# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  validates :title, presence: true, length: { maximum: 50, too_long: :title_too_long }
  validates :description, length: { maximum: 500, too_long: :desc_too_long }, allow_blank: true
  validate :deadline_cannot_be_in_the_past, if: -> { deadline.present? }
  validate :valid_date_format, if: -> { deadline.present? }
  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }

  private

  def deadline_cannot_be_in_the_past
    return unless deadline <= DateTime.yesterday

    errors.add(:deadline, :past_deadline)
  end

  def valid_date_format
    parsed_date = Date.strptime(deadline.to_s, '%Y-%m-%d')
    return if parsed_date.year.between?(Date.today.year, Date.today.year + 10)

    errors.add(:deadline, :out_of_range)
  end
end
