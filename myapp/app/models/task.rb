class Task < ApplicationRecord
  belongs_to :user

  enum status: { untouched: 1, doing: 2, completed: 3 }

  validates :name, presence: true
  validates :name, length: { maximum: 10 }
  validates :description, presence: true
  validates :description, length: { maximum: 50 }

  scope :search, -> (params) do
    name_like(params[:name])
    .status_equal(Task.statuses[params[:status]])
    .includes([:labellings, :labels])
    .label_equal(params[:label_id])
  end

  scope :name_like, -> (name) { where('tasks.name LIKE ?', "%#{name}%") if name.present? }
  scope :status_equal, -> (status) { where('status = ?', status) if status.present? }
  scope :label_equal, -> (label_id){ where(labels: { id: label_id }).left_outer_joins(:labels) if label_id.present? }

  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings

  paginates_per 5
end
