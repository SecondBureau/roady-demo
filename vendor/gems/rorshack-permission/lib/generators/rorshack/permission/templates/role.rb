class Role < ActiveRecord::Base
  include Rorshack::Permission::RoleModelMethods
end
