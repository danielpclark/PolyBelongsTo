ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
# require File.expand_path("../dummy/config/environment.rb",  __FILE__)

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'
require 'securerandom'

unless Rails.version =~ /^4.[2-9]/
  Rails.backtrace_cleaner.remove_silencers!
end
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

#reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

class ActiveSupport::TestCase
  ActiveRecord::Base.send(:include, PolyBelongsTo::Dup)
  CleanAttrs = PolyBelongsTo::PbtAttrSanitizer  
end
