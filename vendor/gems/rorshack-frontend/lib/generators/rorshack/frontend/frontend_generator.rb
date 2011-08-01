require 'rails/generators'
require 'rails/generators/migration'
module Rorshack
  class FrontendGenerator < Rails::Generators::Base
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

#    def copy_default_css
#      directory "stylesheets" , "public/stylesheets"
#    end
    
    def copy_default_layout_and_partials
      directory "views" , "app/views"
    end

    def copy_default_helper
      directory "helpers" , "app/helpers"
    end

    def copy_default_initializer
      template "formtastic.rb" , "config/initializers/formatastic.rb"
    end

  end
end
