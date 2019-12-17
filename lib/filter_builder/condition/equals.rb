module FilterBuilder
  module Condition
    class Equals < Base
      def filter(scope)
        scope.where(field.name => value)
      end
    end
  end
end
