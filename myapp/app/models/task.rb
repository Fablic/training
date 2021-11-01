class Task < ApplicationRecord
  include LiberalEnum

  attr_accessor :label

  belongs_to :user
  counter_culture :user

  validates :title, presence: true, length: { minimum: 3, maximum: 20 }
  validates :detail, length: { maximum: 1000 }

  enum prioritys: { low: 10, normal: 20, high: 30 }
  liberal_enum :prioritys
  validates :priority, presence: true, inclusion: { in: Task.prioritys.values }

  enum statuses: { waiting: 10, doing: 20, done: 30 }
  liberal_enum :statuses
  validates :status, presence: true, inclusion: { in: Task.statuses.values }

  validates :due_date, presence: true
  validate :day_after_today

  has_one_attached :image
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes, message: 'should be less than 5MB' }

  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  scope :search_title, lambda { |title|
    where('tasks.title LIKE ?', "%#{ApplicationRecord.sanitize_sql_like(title)}%") if title.present?
  }
  scope :search_status, ->(status) { where('tasks.status=?', status) if status.present? }
  scope :search_user, ->(user) { where('tasks.user_id=?', user.id) if user.present? }
  scope :search_label, ->(label) { where(['labels.label=?', label]) if label.present? }

  def self.search(user, params)
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    column = Task.column_names.include?(params[:sort]) ? params[:sort] : 'id'
    order = "tasks.#{column} #{direction}"

    eager_load(:task_labels, :labels)
      .search_user(user)
      .search_title(params[:title])
      .search_status(params[:status])
      .search_label(params[:label])
      .order(order)
  end

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  private

  def day_after_today
    return unless !due_date.nil? && (due_date < Time.zone.today)

    errors.add(:due_date, :error)
  end
end
