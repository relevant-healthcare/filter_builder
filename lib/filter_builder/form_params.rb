module FilterBuilder
  class FormParams
    attr_reader :attributes

    def initialize(params)
      @attributes = RecursiveOpenStruct.new(params.to_h)
    end

    def filter_params
      @filter_params ||= deep_cast(attributes)
    end

    def to_h
      filter_params.to_h
    end

    private

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
