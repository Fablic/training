# frozen_string_literal: true

class Task < ApplicationRecord
  has_one :users, dependent: :restrict_with_error
  has_many :task_labels, dependent: :nullify
  has_many :labels, through: :task_labels
  extend Enumerize

  enumerize :status, in: { not_started: 0, wip: 1, completed: 2 }, default: :not_started, scope: true

  scope :search_status, -> (status) { where(status: status) if status.present? }
  scope :search_keyword, -> (keyword) { where(['(tasks.name like? OR tasks.description like? OR labels.name like?)', "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"]) } # rubocop:disable Layout/LineLength
  scope :join_labels, -> { eager_load(:labels) }
  scope :active, -> { where(deleted: 0) }
  scope :user, -> (user_id) { where(user_id: user_id) }
  scope :available, -> (user_id) { active.user(user_id) }

  validates :name, { presence: true, length: { maximum: 50 } }
  validates :description, length: { maximum: 2000 }
  validates :start_at, presence: true, date: true
  validates :due_date_at, presence: true, date: true
  validate :start_end_check?

  def start_end_check?
    return if self.start_at.blank? || self.due_date_at.blank?

    errors.add(:due_date_at, I18n.t('dictionary.messages.invalid_date_diff')) unless
      self.start_at < self.due_date_at
  end

  def self.search(keyword, status, user, order)
    available(user).search_status(status).search_keyword(keyword).join_labels.order(order)
  end

  def self.delete_tasks_by_user_id(user_id)
    tasks = active.where(user_id: user_id)

    return true if tasks.count.zero?

    tasks.update_all(deleted: 1) # rubocop:disable Rails/SkipsModelValidations
  end

  def self.save_task_and_label(user_id, task_id, task_params, label_names)
    if task_id.nil?
      task_params['user_id'] = user_id
      task = Task.new(task_params)
    else
      task = Task.available(user_id).find(task_id)
    end

    ActiveRecord::Base.transaction do
      if task_id.nil?
        task_params['user_id'] = user_id
        task = Task.new(task_params)
        return false unless task.save
      else
        task = Task.available(user_id).find(task_id)
        return false unless task.update(task_params)
      end
      return false unless Label.create_labels(task, label_names)
    end

    true
  rescue StandardError
    false
  end
end
