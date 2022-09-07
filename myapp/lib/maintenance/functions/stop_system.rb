module Maintenance
  module Functions
    class StopSystem
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(9)
        functionManager.stop
      end
    end
  end
end
