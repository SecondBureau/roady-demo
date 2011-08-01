module RorshackAuthentication
  class AccountSession < Authlogic::Session::Base
    
    include ActiveModel::Conversion 

    # Hack Rails 3 / Heroku
      def to_key
        new_record? ? nil : [ self.send(self.class.primary_key) ]
      end

      def persisted? 
        false 
      end

  end
end
