#verify authentication and permission in controller
#  permissionable :as => model_name , #verify permission on specific model
#             :only => [#only verify if visited action is in this list] , 
#             :expect => [#will not verify if visited action in in this list]
#  
#  example:
#      add follow line into players_controller.rb
#      permissionable :as => :user , :only => [:edit, :update , :show]

module Permissionable

  def self.included(base)
    base.class_eval do
      class_attribute :permissionable_configuration, :instance_writer => false
      extend ClassMethods
      before_filter :has_permission?
    end
  end

  module ClassMethods

    def permissionable(opts={}, &block)
      options = opts.dup
      options.symbolize_keys!
      options.assert_valid_keys(:as, :only, :except)
      self.permissionable_configuration ||= {
        :only => Array(options[:only]).dup , 
        :except => Array(options[:except]).dup , 
        :model => as_model(options[:as])
      }
    end

    def as_model(custom_model="")
      unless custom_model.blank?
        custom_model.to_s.camelize
      else
        self.to_s.gsub('Controller','')
      end.singularize.constantize
    end

  end

  protected

    def model
      self.class.permissionable_configuration[:model] 
    end

  private

    def has_permission?
      if need_verify_action?
        if !!!current_user or !can?(ActionMatch.new(action_name).action , model)
          redirect_login_or_root and return
        end
      end
    end 
    
    def need_verify_action?
      return false unless self.class.permissionable_configuration
      options = self.class.permissionable_configuration 
      if options[:only].empty?
        options[:except].empty? || !options[:except].include?(action_name.to_sym)
      else
        options[:only].include?(action_name.to_sym)
      end
    end
end
class ActionMatch
  attr_accessor :action
  
  def initialize(action)
    @action = case action.to_s
      when 'index' then :read
      when 'show' then :read
      when 'new' then :create
      when 'edit' then :update
      else action.to_sym
    end
  end
end
ActionController::Base.send :include, Permissionable
