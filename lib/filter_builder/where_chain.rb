module FilterBuilder
  class WhereChain
    def self.from_filter_params(key:, value:, filtered_table:)
      field = Field.new(name: key, namespace: filtered_table)
      if value.is_a?(Hash)
        from_hash_condition(value, field: field)
      else
        from_value(value, field: field)
      end
    end

    def self.from_hash_condition(hash_condition, field:)
      new(
        clauses: hash_condition.map do |operator_keyword, value|
          WhereClause.new(
            field: field,
            value: value,
            operator: Operator.new(operator_keyword)
          )
        end
      )
    end

    def self.from_value(value, field:)
      new(clauses: [WhereClause.new(field: field, value: value)])
    end

    def initialize(clauses:)
      @clauses = clauses
    end

    def filter(scope)
      clauses.reduce(scope) { |acc, clause| clause.filter(acc) }
    end

    private

    attr_reader :clauses
  end
end
