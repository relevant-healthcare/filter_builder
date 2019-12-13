module FilterBuilder
  class Operator
    def self.from_keyword(keyword)
      predicate = predicate_class(keyword).new
      new(predicate)
    end

    def self.predicate_class(keyword)
      "FilterBuilder::#{keyword.to_s.camelcase}Predicate".constantize
    rescue NameError
      raise UnsupportedOperatorKeywordError.new("Unsupported keyword: #{keyword}")
    end

    def initialize(predicate)
      @predicate = predicate
    end

    delegate :condition_for, to: :predicate

    private

    attr_reader :predicate
  end

  class NilOperator
    def condition_for(field, value)
      { field.name => value }
    end
  end

  class EqualsPredicate
    def condition_for(field, value)
      { field.name => value }
    end
  end

  class MatchesCaseInsensitivePredicate
    def condition_for(field, value)
      ["#{field.namespaced} ~* ?", value]
    end
  end

  class MatchesCaseSensitivePredicate
    def condition_for(field, value)
      ["#{field.namespaced} ~ ?", value]
    end
  end

  class UnsupportedOperatorKeywordError < StandardError; end
end
