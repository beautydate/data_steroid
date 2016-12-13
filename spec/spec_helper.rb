require 'bundler'
Bundler.setup

require 'data_steroid'
require 'byebug'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require file
end
