module Maintenance
  module Core
    class FunctionManager
      def initialize(id)
        @id = id
      end

      def start
        Function.find(@id).update(status: true)
      end

      def stop
        Function.find(@id).update(status: false)
      end
    end
  end
end
