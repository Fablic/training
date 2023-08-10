class Task < ApplicationRecord
  STATUSES = ["Not Started", "In Progress", "Done"].freeze
  
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, numericality: { only_integer: true }

  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels

  scope :dynamic_search, ->(search_params) do
    query = all

    search_params.each do |key, value|
      case key
      when 'name'
        query = query.where('name LIKE ?', "%#{value}%") if value.present?
      when 'status'
        query = query.where(status: value) if value.present?
      end
    end

    query
  end
end
