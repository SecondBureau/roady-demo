module Rorshack
  module Permission
    module Ability

      PERM_CREATE = 1
      PERM_READ   = 2
      PERM_UPDATE = 4
      PERM_DESTROY = 8
      PERM_MANAGE  = 16

      CAN_DO_ACTIONS = %w[read create update destroy manage]
      def self.included(base)
        base.send :include , CanCan::Ability
      end


      def initialize(user)
        user ||= RorshackAuthentication::Account.user_model.new
        return unless user.role

        user.role.permissions.each do |model_name , user_perm|

          kls = model_name.to_s.singularize.camelize

          if Object.const_defined?( kls )
            model = kls.constantize
          else
            next
          end

          CAN_DO_ACTIONS.each do|action|
             required_perm =  self.class.const_get("PERM_#{action.upcase}")
             if required_perm & user_perm == required_perm
               can action.to_sym , model
             end
          end

        end

      end


    end
  end
end
