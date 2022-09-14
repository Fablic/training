class Task < ApplicationRecord
  enum status: { not_started: 1, in_progress: 2, completed: 3 }
  enum priority: { low: 1, middle: 2, high: 3 }

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :detail, presence: true
  validates :detail, length: { maximum: 100 }

  paginates_per 5

  scope :search, -> (params) do
    name_like(params['name'])
    .status_equal(params['status'])
    .includes([:labellings, :labels])
    .label_equal(params['label_id'])
  end

  scope :label_equal, -> (label_id){ where(labels: { id: label_id }).left_outer_joins(:labels) if label_id.present?}
  scope :name_like, -> (name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :status_equal, -> (status) { where('status = ?', status) if status.present? }

  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings
end
