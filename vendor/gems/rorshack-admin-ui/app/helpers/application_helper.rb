module RorshackAdminUi
  module ApplicationHelper
    def extract_columns!(model_klass)
      columns = model_klass.columns.dup
      columns_of_associtaion = model_klass.reflect_on_all_associations.
                               select{| rfl | rfl.macro == :belongs_to }.
                               map{| brfl | 
                                 if brfl.association_class == ActiveRecord::Associations::BelongsToAssociation
                                     [brfl.association_foreign_key]
                                 elsif brfl.association_class == ActiveRecord::Associations::BelongsToPolymorphicAssociation
                                     [brfl.association_foreign_key , brfl.foreign_type]
                                 end
                                }.flatten.compact
      columns.delete_if{|k| k.name.in? columns_of_associtaion || k.name.in?  ['id', 'created_at', 'updated_at', 'admin_only'] }
    end
  end
end
