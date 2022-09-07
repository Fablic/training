class Function < ApplicationRecord
  # ステータスEnum
  enum status: {
    started: '1',
    stopped: '9',
  }

  # 定数
  FUNC_ID_CREATE = 1
  FUNC_ID_UPDATE = 2
  FUNC_ID_DELETE = 3
  FUNC_ID_SYSTEM = 9

  def self.is_started(id)
    Function.statuses[Function.find(id).status] == Function.statuses[:started] ? true : false
  end

  def self.is_stopped(id)
    Function.statuses[Function.find(id).status] == Function.statuses[:stopped] ? true : false
  end
end
