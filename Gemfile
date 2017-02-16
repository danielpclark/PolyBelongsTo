source 'https://rubygems.org'

gemspec

group :test do
  gem 'simplecov'
  gem "codeclimate-test-reporter", '~> 1.0.0'
end

group :development, :test do
  rails_version = ENV["RAILS_VERSION"] || "default"
  # if rails_version =~ /^3\./
  #   gem 'test-unit', ">= 1.2.3"
  # end
  rails = case rails_version
          when "master"
            {github: "rails/rails"}
          when "default"
            ">= 3.1.0"
          else
            "~> #{rails_version}"
          end
  gem "rails", rails
  gem 'color_pound_spec_reporter', '~> 0.0.5'
end
