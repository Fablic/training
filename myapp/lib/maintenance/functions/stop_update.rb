module Maintenance
  module Functions
    class StopUpdate
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(2)
        functionManager.stop
      end
    end
  end
end
