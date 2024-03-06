class Task < ApplicationRecord
    belongs_to :user
    STATUSES = ["Not Started", "In Progress", "Done"].freeze
    PRIORITY = ["High" , "Medium", "Low"].freeze
    validates :name, presence: true ,length: {maximum: 30, length: { maximum: 30, long: I18n.t('flash_msgs.long') } }
    validates :description , length: {maximum: 255, length:{ maximum: 255, long: I18n.t('flash_msgs.long')} }
    validates :status, presence: true, inclusion: { in: STATUSES }
    validates :priority, presence: true, inclusion: { in: PRIORITY }
    validate :duedate_validate
    
    def duedate_validate
      if duedate.present? && duedate < Date.today
        errors.add(:base ,I18n.t('flash_msgs.timeover'))
      end
    end

    def self.ransackable_attributes(auth_object= nil)
      ["name", "description", "status", "priority", "duedate"]
    end    
end
