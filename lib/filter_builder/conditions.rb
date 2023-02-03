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
      def filterbuilder_filter(scope)
        scope.where(field.name => value)
      end
    end

    class DoesNotEqual < Condition
      def filterbuilder_filter(scope)
        scope.where.not(field.name => value)
      end
    end

    class MatchesCaseInsensitive < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} ~* ?", value)
      end
    end

    class DoesNotMatchCaseInsensitive < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} !~* ?", value)
      end
    end

    class MatchesCaseSensitive < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} ~ ?", value)
      end
    end

    class DoesNotMatchCaseSensitive < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} !~ ?", value)
      end
    end

    class Gt < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} > ?", value)
      end
    end

    class Lt < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} < ?", value)
      end
    end

    class Gte < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} >= ?", value)
      end
    end

    class Lte < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} <= ?", value)
      end
    end

    class Between < Condition
      def filterbuilder_filter(scope)
        scope.where("#{field.namespaced_and_quoted} BETWEEN :min AND :max", value)
      end
    end
  end
end
