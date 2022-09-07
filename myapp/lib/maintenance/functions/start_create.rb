module Maintenance
  module Functions
    class StartCreate
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(1)
        functionManager.start
      end
    end
  end
end
