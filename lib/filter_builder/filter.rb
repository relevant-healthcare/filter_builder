class Filter
  attr_reader :filtered_class, :params

  def initialize(filtered_class, params)
    @filtered_class = filtered_class
    @params = params.stringify_keys
  end

  def scope
    params.inject(filtered_class.all) do |acc, (key, value)|
      if filtered_class.reflections.include?(key) && value.is_a?(Hash)
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
end
