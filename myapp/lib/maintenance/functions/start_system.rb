module Maintenance
  module Functions
    class StartSystem
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(9)
        functionManager.start
      end
    end
  end
end
