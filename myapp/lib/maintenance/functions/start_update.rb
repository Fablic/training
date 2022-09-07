module Maintenance
  module Functions
    class StartUpdate
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(2)
        functionManager.start
      end
    end
  end
end
