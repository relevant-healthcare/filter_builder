module FilterBuilder
  module Condition
    class MatchesCaseSensitive < Base
      def filter(scope)
        scope.where("#{field.namespaced} ~ ?", value)
      end
    end
  end
end
