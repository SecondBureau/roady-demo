module Kaminari
  module Helpers
    class Tag
      def initialize(template, options = {}) #:nodoc:
        @template, @options = template, options.dup
        @param_name = @options.delete(:param_name)
        @theme = @options[:theme] ? "#{@options.delete(:theme)}/" : ''
        @params = @options[:params] ? template.params.merge(@options.delete :params) : template.params
      end

      def to_s(locals = {}) #:nodoc:
        @template.render :partial => "kaminari/#{@theme}#{self.class.name.demodulize.underscore}", :locals => @options.merge(locals)
      end

      def page_url_for(page)
        @template.send(detect_route_scope(@params)).url_for @params.merge(@param_name => (page <= 1 ? nil : page))
      end
      protected
      def detect_route_scope(params)
        path_scope = params[:controller].split("/").first
        route_scope = MOUNTED_ROUTES.detect{|mr| mr[:path_scope] == path_scope }
        (route_scope.nil? ? "main_app" : route_scope[:name]).to_sym
      end
    end
  end
end

