module Maintenance
  module Functions
    class StopCreate
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(1)
        functionManager.stop
      end
    end
  end
end
