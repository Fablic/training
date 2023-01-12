# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :string(255)      not null
#  due_date    :datetime         not null
#  priority    :integer
#  status      :integer
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_tasks_on_status   (status)
#  index_tasks_on_user_id  (user_id)
#
class Task < ApplicationRecord
  include AASM

  after_initialize :set_user

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true

  belongs_to :user, optional: true, counter_cache: true

  has_many :taggings
  has_many :tags, through: :taggings
  has_many :limited_tags, -> { order(:name).limit(5) }, through: :taggings, class_name: 'Tag', source: :tag

  scope :by_title, lambda { |title|
    where(Task.arel_table[:title].matches("%#{title}%"))
  }

  enum status: {
    unstarted: 0,
    started: 1,
    completed: 2
  }

  aasm(column: 'status', enum: true)do
    state :unstarted, initial: true
    state :started, :completed

    event :start do
      transitions from: :unstarted, to: :started
    end

    event :complete do
      transitions from: :started, to: :completed
    end
  end

  def set_user
    self.user ||= Current.user if self.new_record?
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
