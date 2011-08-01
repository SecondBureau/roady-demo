require 'net/http'
require 'uri'

module SecondBureau
  module Daryl
      def self.included(klass)
        klass.after_filter :activate_daryl
      end
      
      private

        def activate_daryl
          return unless request.env['HTTP_REFERER'].blank?
          daryl   = ENV['DARYL'] || 'daryl.2bu.ro'
          url     = "http://#{daryl}/page/create"
          agent   = request.env["HTTP_USER_AGENT"]
          host    = request.host
          uri     = request.fullpath
          ip      = request.env['HTTP_X_REAL_IP']
          #logger.warn(request.env.inspect)
          Thread.new do
            Net::HTTP.post_form(URI.parse(url), {'page[ip]'=>ip, 'page[host]'=>host, 'page[agent]' => agent, 'page[uri]' => uri})
          end
        end
  end
end

ActionController::Base.send :include, SecondBureau::Daryl

