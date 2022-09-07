module Maintenance
  module Core
    class FunctionManager
      def initialize(id)
        @id = id
      end

      def start
        Function.find(@id).update(status: Function.statuses[:started])
      end

      def stop
        Function.find(@id).update(status: Function.statuses[:stopped])
      end
    end
  end
end
