class Task < ApplicationRecord
  enum status: { 'open': 1, 'inprogress': 2, 'review': 3, 'reopen': 4, 'done': 5 }
  enum priority: { 'highest': 1, 'higher': 2, 'middle': 3, 'lower': 4, 'lowest': 5 }

  scope :search, -> (search_params) do
    return if search_params.blank?

    summary_like(search_params[:summary])
      .status_is(search_params[:status])
  end
  scope :summary_like, -> (summary) { where('summary LIKE ?', "%#{summary}%") if summary.present? }
  scope :status_is, -> (status) { where(status: status) if status.present? }

  MAX_LENGTH_SUMMARY = 50
  MAX_LENGTH_DESCRIPTION = 255

  validates :summary,
    presence: true,
    length: { maximum: MAX_LENGTH_SUMMARY }

  validates :description,
    length: { maximum: MAX_LENGTH_DESCRIPTION }

  validates :priority,
    presence: true,
    inclusion: { in: self.priorities.keys }

  validates :status,
    presence: true,
    inclusion: { in: self.statuses.keys }

  validate :due_must_be_feature

  def due_must_be_feature
    errors.add(:due, I18n.t('validate.errors.messages.past_time')) if due.present? && due < Time.zone.today
  end
end
