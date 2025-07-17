require 'rspec'
require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end
