module FilterBuilder
  module Operator
    class DoesNotMatchCaseInsensitive
      def condition_for(scope, field, value)
        scope.where("#{field.namespaced} !~* ?", value)
      end
    end
  end
end
