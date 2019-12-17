module FilterBuilder
  module Condition
    class DoesNotMatchCaseSensitive < Base
      def filter(scope)
        scope.where("#{field.namespaced} !~ ?", value)
      end
    end
  end
end
