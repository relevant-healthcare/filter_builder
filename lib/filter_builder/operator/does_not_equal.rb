module FilterBuilder
  module Operator
    class DoesNotEqual
      def condition_for(scope, field, value)
        scope.where.not(field.name => value)
      end
    end
  end
end
