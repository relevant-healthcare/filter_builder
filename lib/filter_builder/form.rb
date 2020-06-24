module FilterBuilder
  class Form
    attr_reader :filtered_class, :filter_params

    def initialize(filtered_class, params = {})
      @filtered_class = filtered_class
      @filter_params = FilterBuilder::Form::Params.new(params.to_h)
    end

    def results
      filter.scope
    end

    def method_missing(method, *args)
      filter_params.attributes.send(method, *args)
    end

    private

    def filter
      FilterBuilder::Filter.new(filtered_class, filter_params)
    end

    class Params
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
end
