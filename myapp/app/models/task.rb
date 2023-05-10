class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :status, inclusion: { in: ['未着手','着手中','完了済'] }

  def self.looks(search, word)
    if search == 'not_started_task'
      @tasks = Task.where('title LIKE? AND status LIKE?', "%#{word}%", "未着手")
    elsif search == 'started_task'
      @tasks = Task.where("title LIKE? AND status LIKE?", "%#{word}%", "着手中")
    elsif search == 'completed_task'
      @tasks = Task.where('title LIKE? AND status LIKE?', "%#{word}%", "完了済")
    else
      @tasks = Task.all
    end
  end
end
