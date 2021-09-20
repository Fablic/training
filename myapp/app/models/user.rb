class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_secure_password validations: true

  validates :name, presence: true, uniqueness: true

  # ユーザ種別（0=一般 / 1=管理者）
  enum role: { nomal: 0, admin: 1 }
end
