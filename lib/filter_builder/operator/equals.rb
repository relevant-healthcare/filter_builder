module FilterBuilder
  module Operator
    class Equals
      def condition_for(scope, field, value)
        scope.where(field.name => value)
      end
    end
  end
end
