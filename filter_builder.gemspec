$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "filter_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "filter_builder"
  s.version     = FilterBuilder::VERSION
  s.authors     = [""]
  s.email       = ["tassosbareiss@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FilterBuilder."
  s.description = "TODO: Description of FilterBuilder."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.8"

  s.add_development_dependency "pg"
end
