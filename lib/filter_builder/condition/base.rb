module FilterBuilder
  module Condition
    class Base
      attr_reader :field, :value

      def initialize(field:, value:)
        @field = field
        @value = value
      end
    end
  end
end
