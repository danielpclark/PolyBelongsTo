source 'https://rubygems.org'

gemspec

group :development, :test do
  rails_version = ENV["RAILS_VERSION"] || "default"
  rails = case rails_version
          when "master"
            {github: "rails/rails"}
          when "default"
            ">= 3.1.0"
          else
            "~> #{rails_version}"
          end
  gem "rails", rails
end
