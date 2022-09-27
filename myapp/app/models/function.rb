class Function < ApplicationRecord
  # 定数
  FUNC_ID_CREATE = 1
  FUNC_ID_UPDATE = 2
  FUNC_ID_DELETE = 3
  FUNC_ID_SYSTEM = 9

  def self.is_stopped?(id)
    !Function.find(id).status
  end
end
