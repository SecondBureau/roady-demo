module SprocketsRailtieExt
  protected
    def asset_environment(app)
      require "sprockets"

      assets = app.config.assets

      env = Sprockets::Environment.new(app.root.to_s)

      env.static_root = File.join(app.root.join("public"), assets.prefix)

      assets.paths.each do |p|
        env.append_path p
      end

      env.logger = Rails.logger

      env.js_compressor  = expand_js_compressor(assets.js_compressor)
      env.css_compressor = expand_css_compressor(assets.css_compressor)

      env
    end
end

Sprockets::Railtie.send :include , SprocketsRailtieExt

