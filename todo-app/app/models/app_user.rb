# frozen_string_literal: true

class AppUser < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, allow_blank: false, uniqueness: true
  validates :hashed_password, presence: true, allow_blank: false
  validates :start_date, presence: true

  def password=(raw_password)
    if raw_password.is_a?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end

  def check_login(raw_password)
    return false if suspended || (!end_date.nil? && end_date < Time.zone.current)
    BCrypt::Password.new(hashed_password) == raw_password
  end

  def admin?
    false # TODO: Implement later.
  end
end
