Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, $twitter_key, $twitter_secret
  provider :facebook, $facebook_key, $facebook_secret , :scope => "email,offline_access,publish_stream,user_checkins"
#  provider :linked_in, $linkedin_key, $linkedin_secret
end
OmniAuth.configure do |config|
  config.path_prefix = "/iauth/auth"
end
