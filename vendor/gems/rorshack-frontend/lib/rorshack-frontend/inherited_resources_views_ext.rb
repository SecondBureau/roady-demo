module InheritedResourcesViews
  module ActionView
    def self.included(base)
      base.class_eval do
        def self.process_view_paths(value)
          PathSet.new(Array.wrap(value))
        end
      end
    end
    
    class PathSet < ::ActionView::PathSet
      def find(*args)
        super(*args)
      rescue ::ActionView::MissingTemplate
        super(args[0], "inherited_resources", args[2], args[3], args[4] , [])
      end
      
      def find_template(original_template_path, format = nil, html_fallback = true)
        super
      rescue ::ActionView::MissingTemplate
        original_template_path.sub!(/^[\w]+/, "inherited_resources")
        super
      end
    end
  end
end
defined?(ActionView) and ActionView::Base.send :include, InheritedResourcesViews::ActionView
