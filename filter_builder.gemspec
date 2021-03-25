$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "filter_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "filter_builder"
  s.version     = FilterBuilder::VERSION
  s.authors     = ["Tassos Bareiss"]
  s.email       = ["tassosbareiss@gmail.com"]
  s.homepage    = "http://relevant.healthcare"
  s.summary     = "Easy way to filter with ActiveRecord"
  s.description = "Intelligently builds up ActiveRecord scopes"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activerecord", ">= 4.2.7"

  s.add_dependency "recursive-open-struct"
  s.add_development_dependency 'rails'
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "byebug"
  s.add_development_dependency "appraisal"
  s.add_development_dependency "rspec_junit_formatter"
end
