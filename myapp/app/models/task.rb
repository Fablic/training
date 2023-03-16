class Task < ApplicationRecord
  belongs_to :user
  has_many :task_tags
  has_many :tags, through: :task_tags

  validates :name, presence: true, length: { maximum: 50 }
  # description はDB上は65,535文字まで許容できるが、区切りよく決めで上限を設定する。
  # DBにアクセスしてエラーを吐くまでにモデルでバリデーションが働くようにしたい意図。
  validates :description, length: { maximum: 5000 }

  enum status: { unstarted: 0, wip: 1, done: 2 }

  scope :status, -> (status) { where(status: status) if status.present? }
  # see: https://api.rubyonrails.org/v7.0.4.2/classes/ActiveRecord/Sanitization/ClassMethods.html#method-i-sanitize_sql_like
  scope :name_contain, -> (name) { where('name like ?', "%#{sanitize_sql_like(name)}%") if name.present? }

  paginates_per 10
end
