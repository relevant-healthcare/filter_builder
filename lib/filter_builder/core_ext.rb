if Module.const_defined? 'ActiveRecord::Base'
  ActiveRecord::Base.class_eval do
    def self.filterbuilder_filter(params)
      FilterBuilder::Filter.new(self, params).scope
    end
  end
end
