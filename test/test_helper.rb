# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "joi"

require "minitest/utils"
require "minitest/autorun"

Dir["#{__dir__}/support/**/*.rb"].sort.each do |file|
  require file
end
