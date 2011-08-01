ENV["RAILS_ENV"] ||= "test"

PROJECT_ROOT = File.expand_path("../..", __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")
require "pp"
require 'bundler/setup'
require 'rails/all'
require "omniauth"
require "authlogic"
require "rorshack-support"
Bundler.require

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'rspec'
require 'rspec/rails'
require 'machinist/active_record'
require 'sham'
require 'database_cleaner'
require 'forgery'

require 'rorshack-authentication'
module RorshackAuthentication
  class ApplicationController < ActionController::Base
  end
  class Account < ActiveRecord::Base
  end
end
Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.backtrace_clean_patterns << %r{gems/}
end
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
