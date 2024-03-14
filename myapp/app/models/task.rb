class Task < ApplicationRecord

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  STATUSES = ["Not Started", "In Progress", "Done"].freeze
  PRIORITY = ["High" , "Medium", "Low"].freeze
  validates :name, presence: true ,length: {maximum: 30, length: { maximum: 30, long: I18n.t('flash_msgs.long') } }
  validates :description , length: {maximum: 255, length:{ maximum: 255, long: I18n.t('flash_msgs.long')} }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, inclusion: { in: PRIORITY }
  validate :duedate_validate

  scope :get_own_tasks, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :get_task_labels, -> (task_id) { select('labels.name').left_joins(:task_labels, :labels).where(id: task_id) if task_id.present? }
  
  scope :with_label_name, -> (name) { 
    joins(:labels).where("labels.name LIKE ?", "%#{name}%") 
  }

  def duedate_validate
    if duedate.present? && duedate < Date.today
      errors.add(:base ,I18n.t('flash_msgs.timeover'))
    end
  end

  def self.ransackable_attributes(auth_object= nil)
    ["name", "description", "status", "priority", "duedate"]
  end    

  def self.ransackable_scopes(_auth_object = nil)
    %i[with_label_name]
  end
end
