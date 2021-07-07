module FilterBuilder
  class Form
    attr_reader :filtered_class, :filter_params

    def initialize(filtered_class, params = {})
      @filtered_class = filtered_class
      @filter_params = FilterBuilder::FormParams.new(params.to_h)
    end

    def results
      filterbuilder_filter.scope
    end

    def method_missing(method, *args)
      filter_params.attributes.send(method, *args)
    end

    private

    def filterbuilder_filter
      FilterBuilder::Filter.new(filtered_class, filter_params)
    end
  end
end
