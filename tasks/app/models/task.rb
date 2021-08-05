class Task < ApplicationRecord
  paginates_per 10

  validates :task_name, presence: true, length: { maximum: 60 }
  validates :detail, length: { maximum: 250 }
  validate :before_datetime, if: :will_save_change_to_limit_date?
  validates :deleted_at_before_type_cast, presence: true, format: { with: Constants::VALID_DATETIME_REGEX }, allow_nil: true, on: :update

  belongs_to :priority, class_name: 'MasterTaskPriority'
  belongs_to :status, class_name: 'MasterTaskStatus'
  has_many :task_links, dependent: :destroy
  has_many :users, through: :task_links
  has_many :label_links, dependent: :destroy
  has_many :labels, through: :label_links

  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :search_task_name, ->(keyword) { keyword.present? ? where('task_name like ?', "%#{keyword}%") : return }
  scope :search_label, ->(keyword) { keyword.present? ? joins(:labels).where('labels.label_name like ?', "%#{keyword}%") : return }
  scope :search_status, ->(statuses) { statuses.present? ? where(status_id: [statuses]) : return }
  scope :sort_task, ->(sort_conditions) { order(sort_conditions) }
  scope :includes_status, -> { includes(:status) }
  scope :includes_priority, -> { includes(:priority) }
  scope :includes_label, -> { includes(:labels) }
  scope :includes_user, ->(user_id) { includes(:users).where(users: { id: user_id }) }

  def before_datetime
    return if limit_date.blank? || limit_date > Time.current

    # 現在日時より前の日時に期限を変更している場合、エラーになる
    errors.add(:limit_date, :cannot_be_before_datetime)
  end

  def labels_save(label_list)
    # ラベルが変更された時、そのタスクと以前のラベルのとの紐付けを削除
    unless labels.nil?
      label_links_records = LabelLink.where(task_id: id)
      label_links_records.destroy_all
    end

    # 入力されたラベルがDBに存在するなら取得し、存在しないなら作成し、紐付けする
    label_list.each do |label|
      inspected_label = labels.where(label_name: label).first_or_create!
      labels << inspected_label
    end
  end
end
