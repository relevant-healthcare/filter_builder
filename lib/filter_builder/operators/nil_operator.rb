module FilterBuilder
  class NilOperator
    def condition_for(field, value)
      { field.name => value }
    end
  end
end
