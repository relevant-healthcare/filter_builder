require 'filter_builder/filter'

if Module.const_defined? 'ActiveRecord::Base'
  ActiveRecord::Base.class_eval do
    def self.filter(params)
      where(id: FilterBuilder::Filter.new(self, params)
                                     .scope
                                     .select(:id))
    end
  end
end
