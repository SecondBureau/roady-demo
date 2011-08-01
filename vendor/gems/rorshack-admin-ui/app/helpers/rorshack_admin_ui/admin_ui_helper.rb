module RorshackAdminUi
  module AdminUiHelper
    def extract_columns!(model)
      columns = model.columns.dup
      columns_of_associtaion = model.reflect_on_all_associations.
                               select{| rfl | rfl.macro == :belongs_to }.
                               map{| brfl |
                                 case brfl.association_class.to_s
                                  when "ActiveRecord::Associations::BelongsToAssociation"
                                     [brfl.association_foreign_key]
                                  when "ActiveRecord::Associations::BelongsToPolymorphicAssociation"
                                     [brfl.association_foreign_key , brfl.foreign_type]
                                 end
                                }.flatten.compact
      columns.delete_if{|k| k.name.in?(columns_of_associtaion) || k.name.in?(['id', 'created_at', 'updated_at', 'admin_only' , "crypted_password", "password_salt", "persistence_token", "perishable_token"]) }
    end
    
    def extract_sortable_columns!( model )
      @extract_sortable_columns ||= model.columns.select{|c|
        c.type.in?([:integer , :date, :datetime, :boolean]) or
        c.name.in? %w[name code title locale]
      }.collect(&:name)
    end
    
    def link_to_sortable( column )
      next_sort_direction = if column.to_s == params[:sort]
                              case params[:sort_direction]
                              when "desc"
                                "asc"
                              when "asc"
                                nil
                              else
                                "desc"
                              end
                            else
                              "desc"
                            end
      sparams = params.dup
      sparams[:only_path] = true
      sparams.delete_if{|k,v| k.to_sym == :requirements}
      if next_sort_direction.nil?
        sparams.delete_if{|k , v| k.to_sym.in? [:sort_direction , :sort] }
      else
        sparams[:sort] = column
        sparams[:sort_direction] = next_sort_direction
      end
      link_to column.titleize, detect_url( sparams )
    end
    
    def extract_associations!( model )
      configured_assoc = RorshackAdminUi::ADMINABLE_MODELS.detect{|ams|
          ams.is_a?(Hash) && ams.keys.first.to_s == model.to_s.underscore
      }
      
      return [] if configured_assoc.nil?
      
      configured_assoc = configured_assoc.values.first

      model.reflect_on_all_associations.select{|r| r.name.in? configured_assoc }
    end
    
    def render_association_form(f , resource , association)
      #to-do : add has_and_belongs_to_many , :has_many_through
      html = 
        case association.macro
        when :belongs_to
          render "form_belongs_to",:f => f , :association => association
        when :has_one
          render "form_has_one",:f => f , :association => association , :resource => resource
        when :has_many
          render "form_has_many",:f => f , :association => association , :resource => resource
        when :has_and_belongs_to_many
          render "form_has_and_belongs_to_many",:f => f , :association => association , :resource => resource
        end
    end
    
    def prepare_has_many_association_form_params(association , resource)
      resource.send(association.name.to_sym).build if resource.send(association.name.to_sym).empty?
      association.name.to_sym
    end
    
    def prepare_has_one_association_form_params(association , resource)
      resource.send("build_#{association.name}") if resource.send(association.name.to_sym).nil?
      association.name.to_sym
    end

    
    def render_object_characteristic(object)
      col = [:name , :title , :email , :nickname , :id].detect{|c| object.respond_to?(c)}
      truncate_length = case action_name
                          when "index"
                            30
                          when "show"
                            200
                          else
                            50
                        end
      content_tag(:span , :title => object.send(col)){ truncate(object.send(col) , :length => truncate_length) }
    end
    
    def render_logo(object)
      existed_logo = object.class.uploaders.keys.detect{|c| object.send(c).file.present?}
      if existed_logo
        image_tag object.send("#{existed_logo}_url" , :thumb)
      end
    end
    def render_collection_table(collection , &block)
      model = collection.first.class
      columns = extract_columns!( model ).map(&:name)
      if need_render_associations = RorshackAdminUi::ADMINABLE_MODELS.detect{|ams|
          ams.is_a?(Hash) && ams.keys.first.to_s == model.to_s.underscore
         }
         columns += need_render_associations.values
      end
      columns = columns.flatten
      columns.map!(&:to_s)
      capture(columns , &block) if block_given?
    end
    
    def render_content(r , col)
      if is_image?(r , col)
        image_tag r.send("#{col}_url" , :thumb)
      elsif is_association?(r , col)
        raw(Array.wrap(r.send(col)).map do |r|
          render "preview_of_resource" , :object => r
        end.join)
      else
        content = r.send(col)
        if content.is_a? String
          raw escape_javascript( content )
        else
          raw content
        end
      end
    end
    private
      def is_association?(r , col)
        !!r.class.reflect_on_association(col.to_sym)
      end
      def is_image?(r , col)
        r.class.respond_to?(:uploaders) && r.class.uploaders.keys.include?(col.to_sym)
      end
      def has_logo?(object)
        object.class.respond_to?(:uploaders)
      end
  end
end
