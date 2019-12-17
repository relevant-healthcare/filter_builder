module FilterBuilder
  class MatchesCaseInsensitiveOperator
    def condition_for(field, value)
      ["#{field.namespaced} ~* ?", value]
    end
  end
end
