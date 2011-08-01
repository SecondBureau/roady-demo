$s3_access_key_id         = ENV['s3_access_key_id'] || 'AKIAI76TH2YOZJ6U4APA'
$s3_secret_access_key     = ENV['s3_secret_access_key'] || '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'
$s3_bucket      = ENV['s3_paperclip_bucket'] || "demo-kidsecret"
$available_locales  = ENV['AVAILABLE_LOCALES'].nil? ? %w[fr en zh] : ENV['AVAILABLE_LOCALES'].split(',')
# omniauth providers
%w[facebook twitter].each do |provider|
  %w[key secret].each {|item| eval("$#{provider}_#{item} =  ENV['#{provider}_#{item}']") }
end
if Rails.env.development? or Rails.env.test?
  $facebook_key = "202719933092946"
  $facebook_secret = "16dd561c3bab5888ab6fc03705ec33cf"
end
