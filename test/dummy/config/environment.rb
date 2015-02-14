# Load the DummyApp.
require File.expand_path('../application', __FILE__)

DummyApp = begin
             if ::Rails.version.to_s =~ /^(?:(?:4\.[2-9])|[5-9])/
               Rails.application
             else
               Dummy::Application
             end
           end

# Initialize the DummyApp.
DummyApp.initialize!
