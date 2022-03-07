require 'digest/sha2'

class User < ApplicationRecord
  PERM_LOGIN = 0b0001
  PERM_ADMIN = 0b1000

  has_many :boards_user
  has_many :board, through: :boards_user

  def get_permission_for(board_id)
    board_user = boards_user.find_by(board_id: board_id)
    return board_user if board_user

    BoardsUser.create(permissions: 0)
  end

  def can_login?
    permissions & PERM_LOGIN != 0
  end

  def admin?
    permissions & PERM_ADMIN != 0
  end

  def self.get_temporary_user()
    # todo remove after login functions are made
    order('id desc').find_by(email: 'admin@example.com')
  end

  def self.create_hash(value)
    seed = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    salt = (0...8).map {
      seed[rand(seed.length)]
    }.join

    plain = salt + value
    salt + Digest::SHA256.hexdigest(plain)
  end

  def check_hash(value)
    salt = this.password[0..7]
    hash = this.password[8..]

    hash == Digest::SHA256.hexdigest(salt + value)
  end
end
