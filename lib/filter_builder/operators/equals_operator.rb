module FilterBuilder
  class EqualsOperator
    def condition_for(field, value)
      { field.name => value }
    end
  end
end
