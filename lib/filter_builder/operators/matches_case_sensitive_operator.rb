module FilterBuilder
  class MatchesCaseSensitiveOperator
    def condition_for(field, value)
      ["#{field.namespaced} ~ ?", value]
    end
  end
end
