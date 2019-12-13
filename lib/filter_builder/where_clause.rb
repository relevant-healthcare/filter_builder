module FilterBuilder
  class WhereClause
    attr_reader :field, :value, :operator

    def initialize(field:, value:, operator: NilOperator.new)
      @field = field
      @value = value
      @operator = operator
    end

    def filter(scope)
      scope.where(predicate)
    end

    private

    def predicate
      operator.predicate_for(field, value)
    end
  end
end
