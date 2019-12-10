module FilterBuilder
  class WhereChain
    def self.from_filter_params(key:, value:, filtered_table:)
      if value.is_a?(Hash)
        from_hash_condition(value, field: key, filtered_table: filtered_table)
      else
        from_value(value, field: key, filtered_table: filtered_table)
      end
    end

    def self.from_hash_condition(hash_condition, field:, filtered_table:)
      new(
        clauses: hash_condition.map do |operator, value|
          WhereClause.new(
            field: field,
            value: value,
            operator: operator,
            filtered_table: filtered_table
          )
        end
      )
    end

    def self.from_value(value, field:, filtered_table:)
      new(
        clauses: [
          WhereClause.new(
            field: field,
            value: value,
            filtered_table: filtered_table
          )
        ]
      )
    end

    def initialize(clauses:)
      @clauses = clauses
    end

    def append_to_scope(scope)
      clauses.reduce(scope) { |acc, clause| clause.append_to_scope(acc) }
    end

    private
    attr_reader :clauses
  end
end
