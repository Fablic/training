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

    if search_params[:search_by] == 'labels'
      query = query.search_by_labels(search_params[:search_text]) if search_params[:search_text].present?
    else
      query = query.search_by_name(search_params[:search_text]) if search_params[:search_text].present?
    end
    
    query
  end

  scope :search_by_name, ->(search_text) do
    where('name LIKE ?', "%#{search_text}%")
  end

  scope :search_by_labels, ->(search_text) do
    joins(:labels).where('labels.name LIKE ?', "%#{search_text}%")
  end
end
