source 'https://rubygems.org'

gemspec
gem "codeclimate-test-reporter", group: :test, require: nil
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
  gem 'color_pound_spec_reporter', '~> 0.0.2'
end
