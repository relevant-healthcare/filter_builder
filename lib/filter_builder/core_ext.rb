require 'filter_builder/filter'

ActiveRecord::Base.class_eval do
  def self.filter(params)
    Filter.new(self, params).scope
  end
end
