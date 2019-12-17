module FilterBuilder
  class WhereClause
    attr_reader :field, :value, :operator

    def initialize(field:, value:, operator:)
      @field = field
      @value = value
      @operator = operator
    end

    def filter(scope)
      scope.where(condition)
    end

    private

    def condition
      operator.condition_for(field, value)
    end
  end
end
