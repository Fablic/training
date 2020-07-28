# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, allow_blank: false
  validates :due_date, presence: true
  validates :status, inclusion: { in: (0..2).to_a }

  belongs_to :app_user

  def self.search_with_condition(search, page, current_user)
    condition = {}
    condition[:app_user] = current_user unless current_user&.admin?
    condition[:status] = search.status if search.status.present?

    Task.where(condition).order(updated_at: search.sort_direction)
        .order(updated_at: search.sort_direction)
        .includes(:app_user)
        .page(page).per(10)
  end
end
