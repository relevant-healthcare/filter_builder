module FilterBuilder
  class Form
    attr_reader :filtered_class, :attributes, :options

    def initialize(filtered_class, params = {}, options = { require_filter: false })
      @filtered_class = filtered_class
      @attributes = RecursiveOpenStruct.new(params.to_h)
      @options = options
    end

    def results
      return filtered_class.none if options[:require_filter] && !filter_params_present?

      filter.scope
    end

    def method_missing(method, *args)
      attributes.send(method, *args)
    end

    def filter_params
      deep_cast(attributes)
    end

    def filter_params_present?
      filter_params.any?
    end

    private

    def filter
      FilterBuilder::Filter.new(filtered_class, filter_params)
    end

    def deep_cast(struct)
      struct.to_h.transform_values do |val|
        case val
        when Array then val.map(&:presence)
        when Hash then deep_cast(val).presence
        else val.presence
        end
      end.compact
    end
  end
end
