module Rorshack
  module Permission
    module RoleModelMethods

      def self.included(base)
        base.class_eval do
          serialize :permissions , Hash
          has_many :users
          def self.default
            @default_role ||= self.where(:is_default_role => true).first
          end
        end
      end
        
    end
  end
end
