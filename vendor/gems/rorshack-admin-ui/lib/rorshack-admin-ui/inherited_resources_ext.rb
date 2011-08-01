module InheritedResources
  module UrlHelpers
  protected
    def generate_url_and_path_helpers(prefix, name, resource_segments, resource_ivars) #:nodoc:
      resource_segments, resource_ivars = handle_shallow_resource(prefix, name, resource_segments, resource_ivars)

      ivars       = resource_ivars.dup
      singleton   = self.resources_configuration[:self][:singleton]
      polymorphic = self.parents_symbols.include?(:polymorphic)

      # If it's not a singleton, ivars are not empty, not a collection or
      # not a "new" named route, we can pass a resource as argument.
      #
      unless (singleton && name != :parent) || ivars.empty? || name == :collection || prefix == :new
        ivars.push "(given_args.first || #{ivars.pop})"
      end

      # In collection in polymorphic cases, allow an argument to be given as a
      # replacemente for the parent.
      #
      if name == :collection && polymorphic
        index = ivars.index(:parent)
        ivars.insert index, "(given_args.first || parent)"
        ivars.delete(:parent)
      end

      # When polymorphic is true, the segments must be replace by :polymorphic
      # and ivars should be gathered into an array, which is compacted when
      # optional.
      #
      if polymorphic
        segments = :polymorphic
        ivars    = "[#{ivars.join(', ')}]"
        ivars   << '.compact' if self.resources_configuration[:polymorphic][:optional]
      else
        segments = resource_segments.empty? ? 'root' : resource_segments.join('_')
        ivars    = ivars.join(', ')
      end

      prefix = prefix ? "#{prefix}_" : ''
      ivars << (ivars.empty? ? 'given_options' : ', given_options')

      class_eval <<-URL_HELPERS, __FILE__, __LINE__
        protected
          def #{prefix}#{name}_path(*given_args)
            given_options = given_args.extract_options!
            main_app.#{prefix}#{segments}_path(#{ivars})
          end

          def #{prefix}#{name}_url(*given_args)
            given_options = given_args.extract_options!
            main_app.#{prefix}#{segments}_url(#{ivars})
          end
      URL_HELPERS
    end
  end
end
