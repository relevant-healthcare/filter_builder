module FilterBuilder
  module Condition
    class DoesNotMatchCaseInsensitive < Base
      def filter(scope)
        scope.where("#{field.namespaced} !~* ?", value)
      end
    end
  end
end
