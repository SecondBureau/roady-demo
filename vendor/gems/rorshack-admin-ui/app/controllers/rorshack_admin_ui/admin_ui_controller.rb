module RorshackAdminUi
  class AdminUiController < InheritedResources::Base
    before_filter :update_resource_class
    helper_method :can_see_admin_only?
    before_filter :check_if_is_admin
    
    helper "rorshack_admin_ui/admin_ui"
    
    layout "rorshack_admin_ui/admin_ui"
    protected

      def update_resource_class
        self.class.resource_class = params[:model_name].singularize.classify.constantize
      end
      def can_see_admin_only?
        true
      end
      
      def collection
        get_collection_ivar || begin
          c = end_of_association_chain
          
          collection_datas = ( c.respond_to?(:scoped) ? c.scoped : c.all )
          
          if params[:search].present? && collection_datas.respond_to?(:search)
            collection_datas = collection_datas.search( params[:search] )
          end
          
          configured_assoc = RorshackAdminUi::ADMINABLE_MODELS.detect{|ams|
            ams.is_a?(Hash) && ams.keys.first.to_s == self.class.resource_class.to_s.underscore
          }
          
          unless configured_assoc.nil? 
            collection_datas = collection_datas.includes( *configured_assoc.values.first )
          end

          collection_datas = collection_datas.page( params[:page] )

          collection_datas = collection_datas.order("#{sort_column} #{sort_direction}")
          
          set_collection_ivar( collection_datas )
        end
      end
    
    private 
    
      def check_if_is_admin
        unless signed_in? and current_user.is_of_role?(:administrators)
          redirect_to main_app.root_path
        end
      end
    
      def resource_request_name
        params[:model_name].to_s.underscore.to_sym
      end
    
      def sort_direction
        params[:sort_direction] if %w[asc desc].include?(params[:sort_direction])
      end

      def sort_column
        params[:sort] if self.class.resource_class.column_names.include?(params[:sort])
      end

  end
end
