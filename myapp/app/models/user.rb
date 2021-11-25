class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :tasks
  has_many :labels
  has_secure_password

  # rubocop:disable Metrics/AbcSize
  def searched_tasks(search_form, page)
    return [] unless search_form.is_a?(SearchForm) && search_form&.valid?

    searched_tasks = tasks
                     .order("tasks.#{search_form.sort_value} #{search_form.order_value}")
    searched_tasks.where!('tasks.name LIKE ?', "%#{search_form.name}%") if search_form.name.present?
    searched_tasks.where!(status: search_form.status) if search_form.status.present?
    if search_form.label_ids.present?
      searched_tasks.includes!(:labels_tasks).where!(labels_tasks: { label_id: search_form.label_ids })
    end
    searched_tasks.includes!(:labels)
    searched_tasks.page(page)
  end
  # rubocop:enable Metrics/AbcSize

  # randomなtoken
  def new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = new_token
    update_attribute(:remember_digest, digest(remember_token))
  end

  def digest(str)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(str, cost: cost)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ログイン情報の破棄
  def forget
    update_attribute(:remember_digest, nil)
  end
end
