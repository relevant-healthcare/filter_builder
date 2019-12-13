module FilterBuilder
  class Operator
    def initialize(keyword = nil)
      @keyword = keyword
    end

    def predicate_for(field, value)
      case keyword
      when :equals then { field.name => value }
      when :matches_case_insensitive then ["#{field.namespaced} ~* ?", value]
      when :matches_case_sensitive then ["#{field.namespaced} ~ ?", value]
      end
    end

    private

    attr_reader :keyword
  end

  class NilOperator
    def predicate_for(field, value)
      { field.name => value }
    end
  end
end
