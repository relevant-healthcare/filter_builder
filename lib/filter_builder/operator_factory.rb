module FilterBuilder
  module OperatorFactory
    def self.from_keyword(keyword)
      operator_class(keyword).new
    end

    def self.operator_class(keyword)
      "FilterBuilder::#{keyword.to_s.camelcase}Operator".constantize
    rescue NameError
      raise UnsupportedOperatorKeywordError.new("Unsupported keyword: #{keyword}")
    end
  end

  class UnsupportedOperatorKeywordError < StandardError; end
end
