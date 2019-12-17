module FilterBuilder
  module Operator
    class MatchesCaseInsensitive
      def condition_for(scope, field, value)
        scope.where("#{field.namespaced} ~* ?", value)
      end
    end
  end
end
