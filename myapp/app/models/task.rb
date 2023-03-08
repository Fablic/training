class Task < ApplicationRecord
  paginates_per 10

  validates :name, presence: true, length: { maximum: 50 }
  # description はDB上は65,535文字まで許容できるが、区切りよく決めで上限を設定する。
  # DBにアクセスしてエラーを吐くまでにモデルでバリデーションが働くようにしたい意図。
  validates :description, length: { maximum: 5000 }

  enum status: { unstarted: 0, wip: 1, done: 2 }

  scope :status, ->(status) { send(status) if status.present? }
  scope :name_contain, -> (name) { where('name like ?', "%#{name}%") if name.present? }
end
