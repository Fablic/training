class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  # description はDB上は65,535文字まで許容できるが、区切りよく決めで上限を設定する。
  # DBにアクセスしてエラーを吐くまでにモデルでバリデーションが働くようにしたい意図。
  validates :description, length: { maximum: 5000 }
end
