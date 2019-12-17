module FilterBuilder
  module ConditionFactory
    def self.from_operator_keyword(keyword, field:, value:)
      condition_class(keyword).new(field: field, value: value)
    end

    def self.condition_class(operator_keyword)
      "FilterBuilder::Condition::#{operator_keyword.to_s.camelcase}".constantize
    rescue NameError
      raise UnsupportedOperatorKeywordError.new("Unsupported keyword: #{operator_keyword}")
    end
  end

  class UnsupportedOperatorKeywordError < StandardError; end
end
