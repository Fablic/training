# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  has_many :labels, dependent: :delete_all
  has_many :tasks, dependent: :delete_all

  enum role: %i[general admin].freeze

  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, format: { without: /\s/, message: I18n.t('errors.messages.space') }, on: :create
  # パスワードが入力された時のみ実行される
  validates :password, length: { minimum: 6 }, format: { without: /\s/, message: I18n.t('errors.messages.space') }, if: :password, on: :update
  validates :role, presence: true
  validate :keep_admin_at_least_one, if: :general?, on: :update # roleカラムがgeneralに更新された時に実行される

  def self.search(params)
    output = self.includes(:tasks)
    output = output.where('email LIKE ?', "%#{params[:email]}%") if params[:email].present?
    output
  end

  private

  def keep_admin_at_least_one
    return if User.admin.count > 1
    errors.add(:base, :keep_admin_at_least_one)
    throw :abort
  end
end
