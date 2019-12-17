module FilterBuilder
  class DefaultOperator
    def condition_for(field, value)
      { field.name => value }
    end
  end
end
