$s3_access_key_id         = ENV['s3_access_key_id'] || 'AKIAJS5ASZKIMWGXRAUQ'
$s3_secret_access_key     = ENV['s3_secret_access_key'] || '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'
$s3_bucket      = ENV['s3_paperclip_bucket'] || "demo-roady"
$available_locales  = ENV['AVAILABLE_LOCALES'].nil? ? %w[fr en zh] : ENV['AVAILABLE_LOCALES'].split(',')
# omniauth providers
%w[facebook twitter].each do |provider|
  %w[key secret].each {|item| eval("$#{provider}_#{item} =  ENV['#{provider}_#{item}']") }
end
if Rails.env.development? or Rails.env.test?
  $facebook_key = "202719933092946"
  $facebook_secret = "16dd561c3bab5888ab6fc03705ec33cf"
end
