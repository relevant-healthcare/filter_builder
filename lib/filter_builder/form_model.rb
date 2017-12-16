module FilterBuilder
  class FormModel
    attr_reader :filtered_class, :attributes

    def initialize(filtered_class, params = {})
      @filtered_class = filtered_class
      @attributes = RecursiveOpenStruct.new(params)
    end

    def results
      @cache ||= filter.scope
    end

    def method_missing(method, *args)
      bust_cache!
      if method.to_s.ends_with? '='
        attributes.send(method, *args)
      else
        val = attributes.send(method)
        return val unless val.nil?
        attributes[method] = RecursiveOpenStruct.new
      end
    end

    def filter_params
      deep_cast_to_hash(attributes)
    end

    private

    def bust_cache!
      @cache = nil
    end

    def filter
      FilterBuilder::Filter.new(filtered_class, filter_params)
    end

    def deep_cast_to_hash(struct)
      struct.to_h.transform_values do |val|
        if val.is_a?(OpenStruct)
          deep_cast_to_hash(value).presence
        else
          cast_value(val)
        end
      end.compact
    end

    def cast_value(value)
      case value
      when Array then value.map(&:presence)
      when Hash then value
      else value.presence
      end
    end
  end
end
