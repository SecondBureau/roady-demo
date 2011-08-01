require 'rails/generators'
require 'rails/generators/migration'
module Rorshack
  module AdminUi
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      def copy_views
        directory "admin_ui" , "app/views/rorshack_admin_ui/admin_ui"
      end
    end
  end
end
