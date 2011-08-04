require File.expand_path('../boot', __FILE__)

require 'pp'
require 'rails/all'
require 'thread'
require 'rake/dsl_definition'


# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module RoadyDemo
  class Application < Rails::Application
    config.time_zone = 'Paris'
    config.encoding = "utf-8"
    config.i18n.default_locale = :fr
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true
  end
end
require "lipsum"

