class Task < ApplicationRecord
  enum priority: { high: 1, middle: 2, low: 3 }
  enum status: { '未着手' => 1, '着手' => 2, '完了' => 3 }

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true
  validates :deadline, presence: true, before_today: true
  validates :priority, presence: true
  validates :status, presence: true

  scope :undeleted, -> { where(deleted: :false) }
  scope :title_like, ->(search_word) { where( 'title LIKE ?', "%#{search_word}%" ) unless search_word.empty? }
  scope :status_eq, ->(search_status) { where( 'status = ?', search_status ) if Task.statuses.has_value?(search_status.to_i) }

  def self.search( search_word, search_status, page = 1)
    Task.undeleted.title_like(search_word).status_eq(search_status).page(page).per(10)
  end
end
