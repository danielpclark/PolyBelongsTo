ENV["RAILS_ENV"] = "test"
#require "codeclimate-test-reporter"
#CodeClimate::TestReporter.start
require 'simplecov'
SimpleCov.start
require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'
require 'color_pound_spec_reporter'
require 'securerandom'

unless Rails.version =~ /^4.[2-9]/
  Rails.backtrace_cleaner.remove_silencers!
end
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

Minitest::Reporters.use! [ColorPoundSpecReporter.new]

class ActiveSupport::TestCase
  CleanAttrs = PolyBelongsTo::Pbt::AttrSanitizer  
end
