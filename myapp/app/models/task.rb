class Task < ApplicationRecord
  belongs_to :user

  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings

  validates :title, presence: true, length: { maximum: 30 }
  validates :deadline, presence: true

  enum status: { not_started: 0, start: 1, completed: 2 }

  scope :where_title, -> (title) { where('title like ?', "%#{title}%") if title.present? }
  scope :where_status, -> (status) { where(status: status) if status.present? }

  scope :deadline_order, -> (v) { %w[asc desc].include?(v) ? order(deadline: v) : order(created_at: :DESC) }

  def save_label(sent_labels)
    current_labels = self.labels.pluck(:name) unless self.labels.nil?
    old_labels = current_labels - sent_labels
    new_labels = sent_labels - current_labels

    old_labels.each do |old|
      self.labels.delete Label.find_by(name: old)
    end

    new_labels.each do |new|
      add_labels = Label.find_or_create_by(name: new)
      self.labels << add_labels
    end
  end
end
