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

  accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }

  enum status: { open: 0, in_progress: 1, closed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  before_save :update_labels_and_relations

  def self.search(query, status, user_id = nil, label_name = nil)
    tasks = all.includes(%i[user labels])
    tasks = tasks.where(user_id: user_id) unless user_id.nil?
    tasks = tasks.where('title LIKE ?', "%#{query}%") if query.present?
    tasks = tasks.where(status: status) if status.present?
    tasks = tasks.joins(:labels).where('labels.name LIKE ?', "%#{label_name}%") if label_name.present?
    tasks
  end

  private

  def update_labels_and_relations
    return if labels_attributes.nil?

    current_labels = labels.to_a
    new_labels = find_or_create_labels

    labels_to_remove = current_labels - new_labels
    remove_task_label_relations(labels_to_remove)

    labels_to_add = new_labels - current_labels
    add_labels(labels_to_add)
  end

  def find_or_create_labels
    new_label_names = labels_attributes.values.map { |attr| attr['name'] }.compact.reject(&:blank?)
    existing_labels = Label.where(name: new_label_names).to_a
    create_missing_labels(new_label_names, existing_labels)
  end

  def create_missing_labels(new_label_names, existing_labels)
    new_label_names.map do |name|
      existing_label = existing_labels.find { |label| label.name == name }
      existing_label || Label.create(name: name)
    end
  end

  def remove_task_label_relations(labels_to_remove)
    return if labels_to_remove.empty?

    task_label_relations.where(label_id: labels_to_remove.map(&:id)).delete_all
  end

  def add_labels(labels_to_add)
    labels_to_add.each { |label| labels << label }
  end
end
