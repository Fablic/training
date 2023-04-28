class TaskStatus < ActiveHash::Base
  self.data = [
    { id: 1, name: '未着手' },
    { id: 2, name: '着手中' },
    { id: 3, name: '完了済' }
  ]
end
