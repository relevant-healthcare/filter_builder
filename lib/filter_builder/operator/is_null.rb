module FilterBuilder
  module Operator
    class IsNull
      def condition_for(scope, field, value)
        scope.where(field.name => nil)
      end
    end
  end
end
