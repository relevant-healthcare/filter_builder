module FilterBuilder
  module Operator
    class IsNotNull
      def condition_for(scope, field, value)
        scope.where.not(field.name => nil)
      end
    end
  end
end
