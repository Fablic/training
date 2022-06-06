class BoardsUser < ApplicationRecord
  PERM_READ = 0b0001
  PERM_WRITE = 0b0010
  PERM_ADMIN = 0b0100
  
  belongs_to :board
  belongs_to :user

  def can_read?
    permissions & PERM_READ != 0
  end

  def can_write?
    permissions & PERM_WRITE != 0
  end

  def admin?
    permissions & PERM_ADMIN != 0
  end
  
end
