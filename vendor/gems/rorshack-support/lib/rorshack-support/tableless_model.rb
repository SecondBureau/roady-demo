module Rorshack
  module Support
    class TablelessModel
      include ActiveModel::Validations
      include ActiveModel::Conversion
      
      def persisted?
          false
      end
      def save(validate = true)
        validate ? valid? : true
      end
      def initialize(params={})
        params.each do |k , v|
          self.try("#{k}=".to_sym , v)
        end
      end
    end
  end
end
