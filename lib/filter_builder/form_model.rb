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
        attributes[method] = self.class.new(filtered_class)
      end
    end

    def filter_params
      deep_cast(attributes)
    end

    private

    def bust_cache!
      @cache = nil
    end

    def filter
      FilterBuilder::Filter.new(filtered_class, filter_params)
    end

    def deep_cast(struct)
      struct.to_h.transform_values do |val|
        case val
        when self.class then val.filter_params.presence
        when Array then val.map(&:presence)
        when Hash then deep_cast(val)
        else val.presence
        end
      end.compact
    end
  end
end