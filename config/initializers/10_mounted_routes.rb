Rails.application.config.after_initialize do
  Rails.application.reload_routes!
  MOUNTED_ROUTES =
    Rails.application.routes.routes.dup.collect do |route|
        reqs = route.requirements.dup
        unless route.app.class.name.to_s =~ /^ActionDispatch::Routing/ or route.name.to_s.blank?
          { :name => route.name.to_s, :verb => route.verb.to_s, :path => route.path , :path_scope => route.app.name.split("::").first.underscore  }
        else
          nil
        end
    end.compact.dup
end
