module FilterBuilder
  class WhereChain
    def self.from_filter_params(key:, value:, filtered_table:)
      field = Field.new(name: key, namespace: filtered_table)
      if value.is_a?(Hash)
        from_condition_key_values(value, field)
      else
        from_single_field_value(value, field)
      end
    end

    def self.from_condition_key_values(condition_key_values, field)
      new(
        conditions: condition_key_values.map do |operator_keyword, value|
          ConditionFactory.from_operator_keyword(
            operator_keyword,
            field: field,
            value: value
          )
        end
      )
    end

    def self.from_single_field_value(value, field)
      new(conditions: [Conditions::Equals.new(field: field, value: value)])
    end

    def initialize(conditions:)
      @conditions = conditions
    end

    def filter(scope)
      conditions.reduce(scope) { |acc, clause| clause.filter(acc) }
    end

    private

    attr_reader :conditions
  end
end
