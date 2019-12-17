module FilterBuilder
  module Condition
    class DoesNotEqual < Base
      def filter(scope)
        scope.where.not(field.name => value)
      end
    end
  end
end
