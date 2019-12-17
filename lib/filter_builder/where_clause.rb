module FilterBuilder
  class WhereClause
    attr_reader :field, :value, :operator

    def initialize(field:, value:, operator:)
      @field = field
      @value = value
      @operator = operator
    end

    def filter(scope)
      operator.condition_for(scope, field, value)
    end
  end
end
