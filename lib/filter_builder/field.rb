module FilterBuilder
  class Field
    attr_reader :name

    def initialize(name:, namespace:)
      @name = name
      @namespace = namespace
    end

    def namespaced
      "\"#{namespace}\".\"#{name}\""
    end

    private

    attr_reader :namespace
  end
end
