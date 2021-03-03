module FilterBuilder
  class Form
    attr_reader :filtered_class, :attributes

    def initialize(filtered_class, params = {})
      @filtered_class = filtered_class
      @attributes = RecursiveOpenStruct.new(params.to_h)
    end

    def results
      filterbuilder_filter.scope
    end

    def method_missing(method, *args)
      attributes.send(method, *args)
    end

    def filter_params
      deep_cast(attributes)
    end

    private

    def filterbuilder_filter
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
