$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kiba'
require 'charlotte_budget'

Dir['spec/support/**/*.rb'].each { |f| require File.absolute_path(f) }