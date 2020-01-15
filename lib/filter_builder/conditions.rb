module FilterBuilder
  module Conditions
    class Condition
      attr_reader :field, :value

      def initialize(field:, value:)
        @field = field
        @value = value
      end
    end

    class Equals < Condition
      def filter(scope)
        scope.where(field.name => value)
      end
    end

    class DoesNotEqual < Condition
      def filter(scope)
        scope.where.not(field.name => value)
      end
    end

    class MatchesCaseInsensitive < Condition
      def filter(scope)
        scope.where("#{field.namespaced} ~* ?", value)
      end
    end

    class DoesNotMatchCaseInsensitive < Condition
      def filter(scope)
        scope.where("#{field.namespaced} !~* ?", value)
      end
    end

    class MatchesCaseSensitive < Condition
      def filter(scope)
        scope.where("#{field.namespaced} ~ ?", value)
      end
    end

    class DoesNotMatchCaseSensitive < Condition
      def filter(scope)
        scope.where("#{field.namespaced} !~ ?", value)
      end
    end

    class IsTrue < Condition
      def filter(scope)
        scope.where("#{field.namespaced} = TRUE")
      end
    end
    class IsFalse < Condition
      def filter(scope)
        scope.where("#{field.namespaced} = FALSE")
      end
    end
    class IsNull < Condition
      def filter(scope)
        scope.where("#{field.namespaced} IS NULL")
      end
    end

    class IsNotNull < Condition
      def filter(scope)
        scope.where("#{field.namespaced} IS NOT NULL")
      end
    end
  end
end
