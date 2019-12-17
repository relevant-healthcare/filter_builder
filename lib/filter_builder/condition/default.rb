module FilterBuilder
  module Condition
    class Default < Base
      def filter(scope)
        scope.where(field.name => value)
      end
    end
  end
end
