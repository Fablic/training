module Maintenance
  module Functions
    class StartDelete
      def self.execute()
        functionManager = Maintenance::Core::FunctionManager.new(3)
        functionManager.start
      end
    end
  end
end
