class Board < ApplicationRecord
  has_many :boards_user
  has_many :board, through: :boards_user

  has_many :tag

  has_many :status
  has_many :priority
end
