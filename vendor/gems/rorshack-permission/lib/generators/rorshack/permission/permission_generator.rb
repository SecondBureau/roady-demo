require 'rails/generators'
require 'rails/generators/migration'
module Rorshack
  class PermissionGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

     # Implement the required interface for Rails::Generators::Migration.
     # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
    def self.next_migration_number(dirname) #:nodoc:
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_roles.rb'
    end
    def create_role_model
      template 'role.rb' , 'app/models/role.rb'
    end
    def create_ability
      template 'ability.rb' , 'app/models/ability.rb'
    end
  end
end
