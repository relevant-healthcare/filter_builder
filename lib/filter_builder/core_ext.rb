require 'filter_builder/filter'

ActiveRecord::Base.class_eval do
  def filter(params)
    FilterBuilder.new(self.class, params).scope
  end
end
