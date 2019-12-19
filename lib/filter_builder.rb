require 'recursive-open-struct'

Dir[
  "#{File.dirname(__FILE__)}/filter_builder/**/*.rb"
].each { |file| require file }

module FilterBuilder
end
