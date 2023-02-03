module FilterBuilder
  class Field
    attr_reader :name

    def initialize(name:, namespace:)
      @name = name
      @namespace = namespace
    end

    def namespaced_and_quoted
      # namespace might be [table_name] or [schema_name].[table_name]
      parts = namespace.split('.') + [name]
      parts.map { |part| Utilities.quote_value(part) }.join('.')
    end

    private

    attr_reader :namespace
  end

  module Utilities
    # Based on https://github.com/relevant-healthcare/relevant/blob/master/app/models/utilities.rb#L30
    def self.quote_value(value)
      already_escaped = !(/^".*"$/ =~ value).nil?
      return value if already_escaped
      "\"#{value}\""
    end
  end
end
