module FilterBuilder
  class WhereClause
    attr_reader :field, :value, :operator, :filtered_table

    def initialize(field:, value:, filtered_table:, operator: nil)
      @field = field
      @value = value
      @operator = operator
      @filtered_table = filtered_table
    end

    def filter(scope)
      scope.where(predicate)
    end

    private

    def predicate
      case operator
      when nil then { field => value }
      when :matches_case_insensitive then ["#{namespaced_field} ~* ?", value]
      when :matches_case_sensitive then ["#{namespaced_field} ~ ?", value]
      else
        raise "Unsupported operator: #{operator}"
      end
    end

    def namespaced_field
      "\"#{filtered_table}\".\"#{field}\""
    end
  end
end
