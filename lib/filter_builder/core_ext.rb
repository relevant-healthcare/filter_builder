if Module.const_defined? 'ActiveRecord::Base'
  ActiveRecord::Base.class_eval do
    # DEPRECATED: use ActiveRecord.filterbuilder_filter instead
    def self.filter(params)
      self.filterbuilder_filter(params)
    end

    def self.filterbuilder_filter(params)
      FilterBuilder::Filter.new(self, params).scope
    end
  end
end
