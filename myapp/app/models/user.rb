# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  has_secure_password
  validates :login_id, { presence: true, length: { maximum: 10 } }
  validates :name, { presence: true, length: { maximum: 20 } }

  scope :search_condition, lambda { |search_params|
    return if search_params.blank?

    name_like(search_params[:name_cont])
    .login_id_is(search_params[:login_id_eq])
  }

  scope :name_like, -> (name_cont) { where('name LIKE ?', "%#{name_cont}%") if name_cont.present? }
  scope :login_id_is, -> (login_id_eq) { where(login_id: login_id_eq) if login_id_eq.present? }
end
