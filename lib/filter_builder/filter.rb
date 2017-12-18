module FilterBuilder
  class Filter
    attr_reader :filtered_class, :params

    def initialize(filtered_class, params = {})
      @filtered_class = filtered_class
      @params = params
    end

    def scope
      params.inject(filtered_class.all) do |acc, (uncast_key, value)|
        key = uncast_key.to_s
        if join_and_recurse?(key, value)
          joined_class = filtered_class.reflections[key].klass
          acc.joins(key.to_sym).merge(Filter.new(joined_class, value).scope)
        elsif acc.respond_to?(key)
          acc.public_send(key, *Array(value))
        elsif acc.respond_to?("with_#{key}")
          acc.public_send("with_#{key}", *Array(value))
        else
          acc.where(key => value)
        end
      end
    end

    private

    def join_and_recurse?(key, value)
      filtered_class.respond_to?(:reflections) &&
        filtered_class.reflections.include?(key) && value.is_a?(Hash)
    end
  end
end
