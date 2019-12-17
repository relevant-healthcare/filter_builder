module FilterBuilder
  module Operator
    class Default
      def condition_for(scope, field, value)
        scope.where(field.name => value)
      end
    end
  end
end
