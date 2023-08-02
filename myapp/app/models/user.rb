class User < ApplicationRecord

    has_many :tasks
    has_many :assigned_tasks, :class_name => 'Task', :foreign_key => 'assigned_user_id'

    validates :first_name, presence: true
    validates :username, presence: true
    validates :email, presence: true
    validates :password, presence: true
    validates :is_admin, presence: true
end
