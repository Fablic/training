# frozen_string_literal: true

class Task < ApplicationRecord # rubocop:disable Style/Documentation

  attr_accessor :labels_attributes

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[open in_progress closed] }
  validates :priority, presence: true, inclusion: { in: %w[high medium low] }
  validates :due_date, presence: true

  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  accepts_nested_attributes_for :labels, allow_destroy: true, reject_if:  proc { |attributes| attributes['name'].blank? }

  enum status: { open: 0, in_progress: 1, closed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  before_save :process_labels

  private

  def process_labels
    return if labels_attributes.nil?

    self.labels.clear
    labels_attributes.values.each do |label_attributes|
      next if label_attributes['name'].blank?
      label = Label.find_or_create_by(name: label_attributes[:name])
      self.labels << label unless self.labels.include?(label)
    end
  end

  def self.search(query, status, user_id)
    tasks = all.includes([:user, :labels])
    tasks = tasks.where(user_id: user_id) unless user_id.nil?
    tasks = tasks.where('title LIKE ?', "%#{query}%") if query.present?
    tasks = tasks.where(status: status) if status.present?
    tasks
  end

end
