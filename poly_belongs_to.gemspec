$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "poly_belongs_to/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "poly_belongs_to"
  s.version     = PolyBelongsTo::VERSION
  s.authors     = ["Daniel P. Clark"]
  s.email       = ["6ftdan@gmail.com"]
  s.homepage    = "https://github.com/danielpclark/PolyBelongsTo"
  s.summary     = "Shorthand belongs_to testing and universal identifiers."
  s.description = "A standard way to check belongs_to relations on any belongs_to Object"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", [">= 3.1", "< 6"]

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "minitest", "~> 5.5"
  s.add_development_dependency "minitest-reporters", "~> 1.0"
  s.add_development_dependency "minitest-rails", "~> 2.1"
end
