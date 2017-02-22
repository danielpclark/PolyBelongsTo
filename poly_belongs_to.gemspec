$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "poly_belongs_to/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "poly_belongs_to"
  s.version     = PolyBelongsTo::VERSION
  s.authors     = ["Daniel P. Clark"]
  s.email       = ["6ftdan@gmail.com"]
  s.homepage    = "https://github.com/danielpclark/PolyBelongsTo"
  s.summary     = "Uniform Omni-Relational ActiveRecord Tools"
  s.description = "Uniform Omni-Relational ActiveRecord Tools.  Includes polymorphic and any belongs_to relation."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "rails", [">= 3.1", "< 6"]

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "minitest-rails", [">= 0.9", "< 3"]
  s.add_development_dependency "minitest-reporters", [">= 0.7.1", "< 2"]
end
