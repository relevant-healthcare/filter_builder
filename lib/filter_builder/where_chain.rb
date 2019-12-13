module FilterBuilder
  class WhereChain
    def self.from_filter_params(key:, value:, filtered_table:)
      field = Field.new(name: key, namespace: filtered_table)
      if value.is_a?(Hash)
        from_predicate_key_values(value, field)
      else
        from_single_field_value(value, field)
      end
    end

    def self.from_predicate_key_values(predicate_key_values, field)
      new(
        clauses: predicate_key_values.map do |operator_keyword, value|
          WhereClause.new(
            field: field,
            value: value,
            operator: Operator.from_keyword(operator_keyword)
          )
        end
      )
    end

    def self.from_single_field_value(value, field)
      new(
        clauses: [
          WhereClause.new(field: field, value: value, operator: NilOperator.new)
        ]
      )
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
