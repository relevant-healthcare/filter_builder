module FilterBuilder
  class Filter
    attr_reader :filtered_class, :params

    def initialize(filtered_class, params = {})
      @filtered_class = filtered_class
      @params = params.to_h
    end

    def scope
      params.inject(filtered_class.all) do |acc, (uncast_key, value)|
        key = uncast_key.to_s
        if join_and_recurse?(key, value)
          joined_class = filtered_class.reflections[key].klass
          acc.joins(key.to_sym).merge(Filter.new(joined_class, value).scope)
        elsif scope_defined?(key.to_sym)
          append_scope(acc, key, value)
        elsif scope_defined?("with_#{key}".to_sym)
          append_scope(acc, "with_#{key}", value)
        else
          WhereChain.from_filter_params(
            filtered_table: filtered_class.table_name,
            key: key,
            value: value
          ).filter(acc)
        end
      end
    end

    private

    def scope_defined?(method_name)
      public_methods_not_from_ancestor.include?(method_name)
    end

    def public_methods_not_from_ancestor
      filtered_class.public_methods(false)
    end

    def join_and_recurse?(key, value)
      filtered_class.respond_to?(:reflections) &&
        filtered_class.reflections.include?(key) && value.is_a?(Hash)
    end

    def append_scope(acc, scope_name, args)
      acc.public_send(scope_name, *[args].flatten(1))
    end
  end
end
