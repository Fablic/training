# frozen_string_literal: true

class Batch::Maintenance
  # バッチを実行
  def self.on
    p 'Maintenance Mode On'
  end

  def self.off
    p 'Maintenance Mode Off'
  end
end
