module Maintenance
  module Functions
    class StopDelete
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(1)
        functionManager.stop
      end
    end
  end
end
