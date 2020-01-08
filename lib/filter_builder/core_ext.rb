# frozen_string_literal: true

if Module.const_defined? 'ActiveRecord::Base'
  ActiveRecord::Base.class_eval do
    def self.filter(params)
      FilterBuilder::Filter.new(self, params).scope
    end
  end
end
