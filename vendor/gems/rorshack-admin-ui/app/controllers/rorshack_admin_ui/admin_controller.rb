module RorshackAdminUi
  
  class AdminController < ApplicationController

    layout "rorshack_admin_ui/admin_ui"
    
    def list
      @model_names = RorshackAdminUi::ADMINABLE_MODELS.map{|_| _.is_a?(Hash) ? _.keys.first : _}
    end
    
  end
  
end
