# frozen_string_literal: true

class Maintainance
  def self.on(reason = nil)
    file = File.open('./config/maintanance.txt', 'w')
    file.puts(reason)
    file.close
  end

  def self.off
    File.delete('./config/maintanance.txt')
  end
end
