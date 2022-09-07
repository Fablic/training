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
end
