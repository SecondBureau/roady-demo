module RorshackPermission
  module UserModelExt

    def self.included(base)
      base.class_eval do

        belongs_to :role
        delegate :name, :to => :role , :prefix => "role" , :allow_nil => true

        def role!(role = "")
          if role.is_a? Role
            self.role = role
          elsif r = Role.find_by_name(role.to_s)
            self.role = r
          else
            self.role = Role.default
          end
          self.save if self.changed?
        end

        def is_of_role?(role = "")
          if role.is_a? Role
            return self.role == role
          elsif  r = Role.find_by_name(role.to_s)
            return self.role == r
          else
            false
          end
        end
      
      end
    end

  end
end

