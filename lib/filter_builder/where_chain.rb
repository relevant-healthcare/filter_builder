module FilterBuilder
  class WhereChain
    attr_reader :field, :condition, :filtered_table

    def initialize(field:, condition:, filtered_table:)
      @field = field
      @condition = condition
      @filtered_table = filtered_table
    end

    def append_to(scope)
      clauses.reduce(scope) { |acc, clause| acc.where(clause.predicate) }
    end

    def clauses
      if condition.is_a?(Hash)
        condition.map do |key, value|
          WhereClause.new(field: field, value: value, operator: key, filtered_table: filtered_table)
        end
      else
        [WhereClause.new(field: field, value: condition, filtered_table: filtered_table)]
      end
    end
  end
end
