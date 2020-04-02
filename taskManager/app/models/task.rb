class Task < ApplicationRecord
  enum status: { 'open': 1, 'inprogress': 2, 'review': 3, 'reopen': 4, 'done': 5 }
  enum priority: { 'highest': 1, 'higher': 2, 'middle': 3, 'lower': 4, 'lowest': 5 }

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  scope :search, -> (search_params) do
    return if search_params.blank?
    summary_like(search_params[:summary])
      .status_is(search_params[:status])
      .from_label(search_params[:label])
  end

  scope :summary_like, -> (summary) { where('summary LIKE ?', "%#{summary}%") if summary.present? }
  scope :status_is, -> (status) { where(status: status) if status.present? }
  scope :from_label, -> (label_name) {
    return if label_name.empty?
    label_id = Label.where('name LIKE ?', "%#{label_name}%").select(:id)
    where(id: task_ids = TaskLabel.where(label_id: label_id).select(:task_id))
  }

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

  def save_labels(labels)
    current_labels = self.labels.pluck(:name) unless self.labels.nil?
    removal = current_labels - labels
    additional = labels - current_labels

    # 除去文言を中間テーブルから削除
    removal.each do |label_name|
      self.labels.delete Label.find_by(name: label_name)
    end

    # 追加文言を中間テーブルに登録
    additional.each do |label_name|
      task_label = Label.find_or_create_by(name: label_name)
      self.labels << task_label
    end
  end
end
