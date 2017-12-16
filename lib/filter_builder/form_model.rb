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

    private

    def bust_cache!
      @cache = nil
    end

    def filter
      FilterBuilder::Filter.new(filtered_class, filter_params)
    end

    def filter_params
      deep_to_h(attributes)
    end

    def deep_to_h(struct)
      struct.to_h.transform_values do |val|
        val.is_a?(OpenStruct) ? deep_to_h(val).presence : val
      end.compact
    end
  end
end
