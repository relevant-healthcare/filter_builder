module FilterBuilder
  module Operator
    class DoesNotEqualOperator
      def condition_for(scope, field, value)
        where.not(field.name => value)
      end
    end
  end
end
